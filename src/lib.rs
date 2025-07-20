use std::fs;

use zed::{settings::LspSettings, LanguageServerId, Result};
use zed_extension_api::{self as zed};

struct LumeBinary {
    path: String,
    args: Vec<String>,
}

struct LumeExtension {
    cached_binary_path: Option<String>,
}

impl LumeExtension {
    fn language_server_binary_path(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<LumeBinary> {
        let binary_settings = LspSettings::for_worktree("lume-lsp", worktree)
            .ok()
            .and_then(|lsp_settings| lsp_settings.binary);

        let binary_args = binary_settings
            .as_ref()
            .map(|binary_settings| binary_settings.arguments.clone().unwrap_or_default())
            .unwrap_or_default();

        if let Some(path) = binary_settings.and_then(|binary_settings| binary_settings.path) {
            return Ok(LumeBinary {
                path,
                args: binary_args,
            });
        }

        if let Some(path) = worktree.which("lume-lsp") {
            return Ok(LumeBinary {
                path,
                args: binary_args,
            });
        }

        if let Some(path) = &self.cached_binary_path {
            if fs::metadata(path).is_ok_and(|stat| stat.is_file()) {
                return Ok(LumeBinary {
                    path: path.clone(),
                    args: binary_args,
                });
            }
        }

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );
        let release = zed::latest_github_release(
            "lume-lang/lume-lsp",
            zed::GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        )?;

        let (platform, arch) = zed::current_platform();
        let asset_name = format!(
            "lume-lsp-{arch}-{os}.tar.gz",
            arch = match arch {
                zed::Architecture::X8664 => "x86_64",
                zed::Architecture::X86 => "x86",
                zed::Architecture::Aarch64 => "aarch64",
            },
            os = match platform {
                zed::Os::Windows => "windows-msvc",
                zed::Os::Mac => "apple-darwin",
                zed::Os::Linux => "unknown-linux-gnu",
            },
        );

        let asset = release
            .assets
            .iter()
            .find(|asset| asset.name == asset_name)
            .ok_or_else(|| format!("no asset found matching {asset_name:?}"))?;

        let version_dir = format!("lume-lsp-{}", release.version);
        let binary_path = format!("{version_dir}/lume-lsp");

        if !fs::metadata(&binary_path).is_ok_and(|stat| stat.is_file()) {
            zed::set_language_server_installation_status(
                language_server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );

            zed::download_file(
                &asset.download_url,
                &version_dir,
                zed::DownloadedFileType::GzipTar,
            )
            .map_err(|e| format!("failed to download file: {e}"))?;

            let entries =
                fs::read_dir(".").map_err(|e| format!("failed to list working directory {e}"))?;
            for entry in entries {
                let entry = entry.map_err(|e| format!("failed to load directory entry {e}"))?;
                if entry.file_name().to_str() != Some(&version_dir) {
                    fs::remove_dir_all(entry.path()).ok();
                }
            }
        }

        self.cached_binary_path = Some(binary_path.clone());

        Ok(LumeBinary {
            path: binary_path,
            args: binary_args,
        })
    }
}

impl zed::Extension for LumeExtension {
    fn new() -> Self
    where
        Self: Sized,
    {
        LumeExtension {
            cached_binary_path: None,
        }
    }

    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let lsp_binary = self.language_server_binary_path(language_server_id, worktree)?;

        Ok(zed::Command {
            command: lsp_binary.path,
            args: lsp_binary.args,
            env: Vec::new(),
        })
    }
}

zed::register_extension!(LumeExtension);

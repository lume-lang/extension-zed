use zed_extension_api as zed;

struct LumeExtension {
    // ... state
}

impl zed::Extension for LumeExtension {
    fn new() -> Self
    where
        Self: Sized,
    {
        LumeExtension {}
    }
}

zed::register_extension!(LumeExtension);

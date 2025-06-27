import Adw from "gi://Adw"
import Gio from "gi://Gio"
import { register } from "gnim/gobject"
import { createRoot, createSettings } from "gnim"
import { schema, SettingsContext } from "./settings"
import AppWindow from "./AppWindow"

@register()
export class App extends Adw.Application {
  declare private window: Adw.Window

  constructor() {
    super({
      applicationId: import.meta.domain,
      flags: Gio.ApplicationFlags.FLAGS_NONE,
    })
  }

  vfunc_startup(): void {
    super.vfunc_startup()

    createRoot((dispose) => {
      this.connect("shutdown", dispose)

      const settings = createSettings(new Gio.Settings({ schemaId: import.meta.domain }), schema)

      return (
        <SettingsContext value={settings}>
          {() => <AppWindow app={this} ref={(self) => (this.window = self)} />}
        </SettingsContext>
      )
    })
  }

  vfunc_activate(): void {
    this.window?.present()
  }
}

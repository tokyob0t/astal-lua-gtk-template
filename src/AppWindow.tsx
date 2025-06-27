import Adw from "gi://Adw"
import Gtk from "gi://Gtk"
import GLib from "gi://GLib"
import { isTodo, useSettings } from "./settings"
import { createState, For } from "gnim"

interface AppWindowProps {
  app: Adw.Application
  ref: (self: Adw.ApplicationWindow) => void
}

export default function AppWindow({ app, ref }: AppWindowProps) {
  const { todos, setTodos } = useSettings()
  const [newTodo, setNewTodo] = createState("")
  const todoList = todos((t) => t.filter(isTodo))

  function addNew() {
    if (!newTodo.get()) return

    setTodos((todos) => [
      ...todos,
      {
        label: GLib.Variant.new("s", newTodo.get()),
        done: GLib.Variant.new("b", false),
      },
    ])
    setNewTodo("")
  }

  function toggle(index: number) {
    setTodos((todos) => {
      const todo = todos[index]
      todo.done = GLib.Variant.new("b", !todo.done.get_boolean())
      return todos
    })
  }

  function remove(index: number) {
    setTodos((todos) => todos.filter((_, i) => i !== index))
  }

  return (
    <Adw.ApplicationWindow
      $={ref}
      application={app}
      title={_("Awesome Todo App")}
      defaultHeight={600}
      defaultWidth={500}
    >
      <Adw.ToolbarView>
        <Adw.HeaderBar $type="top">
          <Adw.WindowTitle $type="title" title={_("Awesome Todo App")} />
        </Adw.HeaderBar>
        <Gtk.ScrolledWindow>
          <Adw.Clamp maximumSize={500}>
            <Gtk.Box
              marginTop={8}
              marginBottom={8}
              marginEnd={8}
              marginStart={8}
              spacing={8}
              orientation={Gtk.Orientation.VERTICAL}
            >
              <Gtk.ListBox class="boxed-list" selectionMode={Gtk.SelectionMode.NONE}>
                <Adw.EntryRow
                  title={_("New Todo")}
                  text={newTodo}
                  onNotifyText={({ text }) => setNewTodo(text)}
                  onEntryActivated={addNew}
                />
              </Gtk.ListBox>
              <Gtk.ListBox class="boxed-list" selectionMode={Gtk.SelectionMode.NONE}>
                <For each={todoList}>
                  {(todo, index) => (
                    <Adw.ActionRow title={todo.label}>
                      <Gtk.Button
                        valign={Gtk.Align.CENTER}
                        class="flat destructive-action"
                        tooltipText={_("Remove")}
                        onClicked={() => remove(index.get())}
                      >
                        <Gtk.Image iconName="user-trash-symbolic" />
                      </Gtk.Button>
                      <Gtk.Switch
                        valign={Gtk.Align.CENTER}
                        active={todo.done}
                        onNotifyActive={() => toggle(index.get())}
                      />
                    </Adw.ActionRow>
                  )}
                </For>
              </Gtk.ListBox>
            </Gtk.Box>
          </Adw.Clamp>
        </Gtk.ScrolledWindow>
      </Adw.ToolbarView>
    </Adw.ApplicationWindow>
  )
}

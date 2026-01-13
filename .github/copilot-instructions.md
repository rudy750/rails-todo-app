# Rails Todo App - Developer Guide & AI Context

## 🏗 Project Architecture & tech Stack
- **Framework**: Rails 6.1.7.10 (Running on Ruby 3.2.9)
- **Frontend Strategy**: Hotwire (Turbo & Stimulus) over classic JS/JSON.
  - Using `importmap-rails` for asset management (no Webpack/Node).
  - **Styles**: Custom "Modern Minimalist" theme overriding Bootstrap 5.3 variables (`app/assets/stylesheets/application.scss`).
  - **Icons**: Inline SVGs used directly in views (no icon fonts/libraries).
- **Database**: SQLite3.

## ⚡️ Critical Workflows & Commands
**Note**: This project requires strict versioning for Bundler and Ruby.

- **Start Server**: 
  ```bash
  bundle _2.5.21_ exec rails server
  ```
- **Run Console**:
  ```bash
  bundle _2.5.21_ exec rails console
  ```
- **Asset Management**:
  - If CSS/JS changes aren't reflecting, clear cache:
    ```bash
    bundle _2.5.21_ exec rails assets:clobber
    ```
  - When adding new JS controllers, verify they are linked in `app/assets/config/manifest.js`.

## 🧩 Key Patterns & Conventions

### 1. Dynamic Updates (Hotwire)
Prefer **Turbo Streams** (`*.turbo_stream.erb`) for DOM updates instead of JSON APIs + manual DOM manipulation.
*   **Example**: See `app/views/todos/toggle.turbo_stream.erb`.
*   **Pattern**: 
    1.  Controller responds to `format.turbo_stream`.
    2.  Create a matching view file (e.g., `action_name.turbo_stream.erb`).
    3.  Use `<%= turbo_stream.replace @model %>` or `<%= turbo_stream.update "dom_id" %>`.

### 2. Styling (Bootstrap overrides)
*   **Location**: `app/assets/stylesheets/application.scss`.
*   **Rule**: Define variables (e.g., `$primary`) **before** `@import "bootstrap";` to ensure they override defaults.
*   **Theme**: Slate/Emerald color palette (`#334155`, `#059669`).

### 3. Ruby 3.2 Compatibility Patches
*   **`config/boot.rb`**: Includes manual `require "logger"` to fix missing constant errors in Rails 6 + Ruby 3.2.
*   **`ApplicationRecord`**: Uses `self.abstract_class = true` (Rails 6 style), not `primary_abstract_class` (Rails 7 style).

## ⚠️ Common Pitfalls
- **Environment**: If specific gem versions fail, check `Gemfile.lock` and enforce with `bundle _version_`.
- **Assets**: `sprockets` is used. Do not expect Webpacker/Vite behavior.
- **Routing**: `toggle` action on Todos is a `PATCH` request to `/todos/:id/toggle`.

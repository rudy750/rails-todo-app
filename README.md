# 📝 Ruby on Rails Todo App

A simple, elegant todo list application built with Ruby on Rails 7.1 to demonstrate the framework's best features and conventions.

## 🎯 Features

- ✅ Create, read, update, and delete todos (CRUD operations)
- ✅ Mark todos as complete/incomplete
- ✅ Beautiful Bootstrap 5 UI
- ✅ Responsive design for all devices
- ✅ Form validations
- ✅ Flash messages for user feedback
- ✅ Turbo/Hotwire integration for fast, SPA-like experience
- ✅ RESTful routing
- ✅ ActiveRecord ORM with SQLite database

## 🚀 Tech Stack

- **Ruby**: 3.2.2
- **Rails**: 7.1.0
- **Database**: SQLite3
- **Frontend**: Bootstrap 5.3, Hotwire (Turbo & Stimulus)
- **Server**: Puma

## 📋 Prerequisites

Before running this application, make sure you have the following installed:

- Ruby 3.2.2 or higher
- Bundler gem
- SQLite3

### Installing Ruby

**On macOS** (using Homebrew):
```bash
brew install ruby@3.2
```

**On macOS** (using rbenv - recommended):
```bash
brew install rbenv
rbenv install 3.2.2
rbenv global 3.2.2
```

**On Linux**:
```bash
# Using rbenv
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
rbenv install 3.2.2
rbenv global 3.2.2
```

## 🛠️ Installation & Setup

1. **Clone or navigate to the repository**:
   ```bash
   cd ruby-to-do
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Setup the database**:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the Rails server**:
   ```bash
   rails server
   ```
   Or simply:
   ```bash
   rails s
   ```

5. **Open your browser** and visit:
   ```
   http://localhost:3000
   ```

## 🎓 Rails Features Demonstrated

### 1. **Convention over Configuration**
Rails follows the principle of "Convention over Configuration". Notice how:
- Models are singular (`Todo`)
- Controllers are plural (`TodosController`)
- Database tables are plural (`todos`)
- No XML configuration files needed!

### 2. **ActiveRecord ORM**
The `Todo` model ([app/models/todo.rb](app/models/todo.rb)) demonstrates:
- **Validations**: Ensuring data integrity without writing SQL
- **Scopes**: Reusable query methods (`.completed`, `.pending`, `.recent`)
- **Custom methods**: Business logic encapsulation

```ruby
# Beautiful, readable database queries
Todo.completed.recent  # Get all completed todos, ordered by most recent
```

### 3. **RESTful Routes**
Rails uses resourceful routing ([config/routes.rb](config/routes.rb)):
```ruby
resources :todos  # Automatically creates 7 standard routes
```

This generates:
| HTTP Method | Path | Controller#Action | Purpose |
|-------------|------|-------------------|---------|
| GET | /todos | todos#index | List all todos |
| GET | /todos/new | todos#new | Show form for new todo |
| POST | /todos | todos#create | Create a new todo |
| GET | /todos/:id | todos#show | Show a specific todo |
| GET | /todos/:id/edit | todos#edit | Show form to edit todo |
| PATCH/PUT | /todos/:id | todos#update | Update a specific todo |
| DELETE | /todos/:id | todos#destroy | Delete a specific todo |

### 4. **MVC Architecture**
Clear separation of concerns:
- **Models** ([app/models/](app/models/)): Business logic and data
- **Views** ([app/views/](app/views/)): User interface templates
- **Controllers** ([app/controllers/](app/controllers/)): Request handling and flow

### 5. **DRY Principle (Don't Repeat Yourself)**
- Partials for reusable view components (`_todo.html.erb`)
- Layouts for shared page structure (`application.html.erb`)
- Helpers for view logic

### 6. **Migrations**
Database changes are versioned and reversible:
```bash
rails db:migrate      # Apply migrations
rails db:rollback     # Undo last migration
```

### 7. **Hotwire/Turbo**
Modern, fast user experience without writing JavaScript:
- Turbo Drive: Intercepts link clicks for faster navigation
- Turbo Frames: Update parts of the page without full reload
- Minimal JavaScript needed!

### 8. **Built-in Helpers**
Rails provides helpers that make development easier:
- `form_with`: Smart form generation
- `link_to`: HTML-safe link generation
- `time_ago_in_words`: Human-readable timestamps
- `button_to`: RESTful button forms

### 9. **Asset Pipeline**
Organized asset management:
- SCSS for CSS preprocessing
- Import maps for JavaScript
- Bootstrap integration

## 📁 Project Structure

```
ruby-to-do/
├── app/
│   ├── controllers/      # Request handlers
│   │   └── todos_controller.rb
│   ├── models/           # Data models
│   │   └── todo.rb
│   ├── views/            # Templates
│   │   ├── layouts/
│   │   │   └── application.html.erb
│   │   └── todos/
│   │       ├── index.html.erb
│   │       ├── edit.html.erb
│   │       ├── new.html.erb
│   │       ├── show.html.erb
│   │       └── _todo.html.erb
│   ├── assets/           # CSS, images
│   │   └── stylesheets/
│   │       └── application.scss
│   └── javascript/       # JavaScript files
│       └── application.js
├── config/
│   ├── routes.rb         # URL routing
│   ├── database.yml      # Database config
│   └── environments/     # Environment configs
├── db/
│   ├── migrate/          # Database migrations
│   ├── schema.rb         # Current database schema
│   └── seeds.rb          # Sample data
├── Gemfile               # Ruby dependencies
└── README.md
```

## 🎨 Key Ruby Features

### 1. **Blocks and Iterators**
```ruby
@todos.each do |todo|
  # Process each todo
end
```

### 2. **Symbols**
Lightweight, immutable identifiers:
```ruby
validates :title, presence: true
```

### 3. **String Interpolation**
```ruby
"Created #{todo.created_at} ago"
```

### 4. **Method Chaining**
```ruby
Todo.completed.recent.limit(10)
```

### 5. **Question Mark Methods**
```ruby
todo.completed?  # Returns true or false
```

### 6. **Bang Methods**
```ruby
todo.toggle_completion!  # Modifies and saves
```

## 🧪 Testing

Run tests with:
```bash
rails test
```

## 🔧 Common Rails Commands

```bash
# Database
rails db:create           # Create database
rails db:migrate          # Run migrations
rails db:seed             # Load seed data
rails db:reset            # Drop, create, migrate, seed

# Server
rails server              # Start development server
rails console             # Interactive Ruby shell with app loaded

# Generate
rails generate model Todo title:string completed:boolean
rails generate controller Todos
rails generate migration AddDescriptionToTodos description:text

# Other
rails routes              # Show all routes
rails about               # Show Rails version and info
```

## 📝 Usage Guide

### Creating a Todo
1. Enter a title in the "Add New Todo" form
2. Optionally add a description
3. Click "Add Todo"

### Marking as Complete
- Click the "✓ Complete" button on any pending todo
- Click "↩️ Undo" to mark it as pending again

### Editing a Todo
1. Click "✏️ Edit" on any todo
2. Modify the title, description, or completion status
3. Click "Update Todo"

### Deleting a Todo
- Click "🗑️ Delete" and confirm the action

## 🌟 Best Practices Demonstrated

1. ✅ **RESTful design** - Standard HTTP methods and resource routing
2. ✅ **Data validation** - Prevent invalid data at model level
3. ✅ **Security** - CSRF protection, parameter filtering
4. ✅ **User feedback** - Flash messages for all actions
5. ✅ **Responsive design** - Works on all screen sizes
6. ✅ **Database indexing** - Optimized queries
7. ✅ **Semantic HTML** - Accessible and SEO-friendly
8. ✅ **Code organization** - MVC pattern strictly followed

## 🐛 Troubleshooting

**Server won't start:**
```bash
# Make sure all gems are installed
bundle install

# Check if another server is running on port 3000
lsof -ti:3000
```

**Database errors:**
```bash
# Reset the database
rails db:reset
```

**Asset issues:**
```bash
# Clear cache and restart
rails tmp:clear
rails assets:clobber
```

## 📚 Learning Resources

- [Ruby on Rails Guides](https://guides.rubyonrails.org/) - Official Rails documentation
- [Rails API Documentation](https://api.rubyonrails.org/) - Detailed API reference
- [The Ruby on Rails Tutorial](https://www.railstutorial.org/) - Comprehensive book
- [Hotwire Documentation](https://hotwired.dev/) - Modern Rails frontend

## 🤝 Contributing

This is a learning project. Feel free to:
- Fork the repository
- Create a feature branch
- Make your changes
- Submit a pull request

## 📄 License

This project is open source and available for educational purposes.

## 🎉 Next Steps

To extend this application, try:
1. Adding user authentication (Devise gem)
2. Implementing todo categories/tags
3. Adding due dates and reminders
4. Creating todo sharing features
5. Adding search functionality
6. Implementing todo priorities
7. Adding file attachments (Active Storage)
8. Creating an API (Rails API mode)

---

**Happy coding! 🚀**

Built with ❤️ using Ruby on Rails

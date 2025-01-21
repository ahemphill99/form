# Catering Form Application Documentation

## Overview
A Ruby on Rails application that allows users to create and manage multi-step forms for catering services. The application features a modern, animated interface using Hotwire (Turbo + Stimulus) for seamless form transitions.

## Technology Stack
- **Backend**: Ruby on Rails 8.0.1
- **Frontend**: 
  - Hotwire (Turbo + Stimulus)
  - TailwindCSS
  - JavaScript
- **Authentication**: Devise
- **Database**: PostgreSQL

## Installation

1. Clone the repository
```bash
git clone <repository-url>
cd catering_form
```

2. Install dependencies
```bash
bundle install
yarn install
```

3. Setup database
```bash
rails db:create
rails db:migrate
```

4. Start the server
```bash
bin/dev
```

## Key Features
1. Multi-step form with animated transitions
2. Admin dashboard for form management
3. Public form sharing via unique tokens
4. Various question types (text, choice, date, number, radio, checkbox)
5. Form response tracking
6. Embeddable forms via iframe

## Core Components

### Models

#### User
- Authentication and form ownership
- Devise model with standard authentication fields

#### Form
```ruby
class Form < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :form_responses, dependent: :destroy
  
  validates :title, presence: true
  validates :public_token, presence: true, uniqueness: true
  
  before_validation :set_public_token, on: :create
  after_create :create_fixed_questions
  
  def to_param
    return id.to_s unless caller_locations(1,1)[0].label.include?('public_form')
    public_token
  end
  
  def embed_code(host = nil)
    url = if host
      Rails.application.routes.url_helpers.public_form_url(self, host: host)
    else
      Rails.application.routes.url_helpers.public_form_path(self)
    end
    %Q(<iframe src="#{url}" width="100%" height="600" frameborder="0"></iframe>)
  end
end
```

#### Question
```ruby
class Question < ApplicationRecord
  belongs_to :form
  
  enum question_type: {
    text: 0,
    choice: 1,
    date: 2,
    number: 3,
    radio: 4,
    checkbox: 5
  }
  
  validates :question_text, presence: true
  validates :question_type, presence: true
  validates :order, presence: true, numericality: { only_integer: true }
end
```

### Controllers

#### FormsController
Handles admin form management:
- CRUD operations for forms
- Form response viewing
- Embedding code generation

#### QuestionsController
Manages question operations:
- Question creation and editing
- Question order management
- Question type configuration

#### Public::FormsController
Handles public form access:
- Form display
- Response submission
- Token validation

#### Public::QuestionsController
Manages the multi-step form interface:
- Question navigation
- Response storage
- Progress tracking

### Views

#### Admin Interface
- Form management dashboard
- Question editor
- Response viewer

#### Public Interface
- Multi-step form display
- Progress indicator
- Animated transitions

### JavaScript

#### Slide Controller
```javascript
// app/javascript/controllers/slide_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:before-render", (event) => {
      event.preventDefault()
      
      const newFrame = event.detail.newFrame
      newFrame.classList.add("translate-x-full")
      
      Promise.resolve()
        .then(() => {
          this.element.classList.add("-translate-x-full", "transition-transform", "duration-500", "ease-in-out")
          newFrame.classList.add("transition-transform", "duration-500", "ease-in-out")
          return new Promise(resolve => setTimeout(resolve, 50))
        })
        .then(() => {
          newFrame.classList.remove("translate-x-full")
          return new Promise(resolve => setTimeout(resolve, 500))
        })
        .then(() => {
          event.detail.resume()
        })
    })
  }
}
```

## Database Schema

### Forms
```ruby
create_table "forms", force: :cascade do |t|
  t.string "title", null: false
  t.text "description"
  t.string "public_token", null: false
  t.bigint "user_id", null: false
  t.timestamps
  t.index ["public_token"], unique: true
  t.index ["user_id"]
end
```

### Questions
```ruby
create_table "questions", force: :cascade do |t|
  t.bigint "form_id", null: false
  t.string "question_text", null: false
  t.integer "question_type", null: false
  t.boolean "required", default: false
  t.integer "order", null: false
  t.timestamps
  t.index ["form_id"]
end
```

### Form Responses
```ruby
create_table "form_responses", force: :cascade do |t|
  t.bigint "form_id", null: false
  t.jsonb "response_data", default: {}
  t.integer "status", default: 0
  t.timestamps
  t.index ["form_id"]
end
```

## Routes
```ruby
Rails.application.routes.draw do
  devise_for :users
  
  root to: 'dashboard#index'
  
  resources :forms do
    resources :questions
  end
  
  namespace :public do
    resources :forms, param: :public_token do
      resources :questions do
        member do
          post :answer
        end
      end
    end
  end
end
```

## Styling
The application uses TailwindCSS for styling with custom configurations:
- Responsive design
- Custom animation classes
- Form element styling
- Admin dashboard layout

## Security Considerations
1. Authentication using Devise
2. Public form access via secure tokens
3. Form ownership validation
4. CSRF protection
5. Response data validation

## Testing
The application includes:
- Model specs for business logic
- Controller specs for actions
- System tests for user flows
- JavaScript tests for animations

## Deployment
Standard Rails deployment process:
1. Asset precompilation
2. Database migrations
3. Environment configuration
4. Server setup (Nginx/Puma)

## Contributing
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
This project is licensed under the MIT License.

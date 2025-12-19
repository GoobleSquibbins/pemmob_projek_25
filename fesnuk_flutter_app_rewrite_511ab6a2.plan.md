---
name: Fesnuk Flutter App Rewrite
overview: Complete rewrite of Fesnuk Flutter app with MVVM architecture using GetX, implementing 5 main pages (Homepage, Nooks List, Nook Detail, Post Detail, Post Create) with bottom navigation, pull-to-refresh lists, and full-screen image viewer.
todos:
  - id: setup
    content: Set up project dependencies (get, http, cached_network_image, image_picker, photo_view, carousel_slider, intl) and create folder structure (core, data, presentation, routes)
    status: pending
  - id: models
    content: Create data models (NookModel, PostModel, CommentModel) based on API response structure
    status: pending
    dependencies:
      - setup
  - id: api_layer
    content: Implement API service and repository layer with all endpoints (nooks, posts, comments, reactions) and Azure Blob Storage image upload service
    status: pending
    dependencies:
      - models
  - id: utils
    content: "Create utility functions: DateFormatter for relative time, validators for form validation, API config, ImageHelper for URL construction and Azure upload, EmojiHelper for unicode conversion, UUIDGenerator"
    status: pending
    dependencies:
      - setup
  - id: widgets
    content: "Build modular, reusable widgets: PostCard (with reactions), NookCard, ImageCarousel, ImageViewer, CommentItem (with reactions and replies), EmojiPicker, ReactionDisplay, ReactionButton. Ensure all widgets are parameterized, accept callbacks, and follow single responsibility principle"
    status: pending
    dependencies:
      - utils
  - id: controllers
    content: "Implement GetX controllers: HomeController, NooksListController, NookDetailController, PostDetailController, CreatePostController"
    status: pending
    dependencies:
      - api_layer
      - utils
  - id: pages
    content: "Build all 5 pages: HomePage, NooksListPage, NookDetailPage, PostDetailPage, CreatePostPage with proper UI and integration with controllers"
    status: pending
    dependencies:
      - controllers
      - widgets
  - id: navigation
    content: Set up navigation structure with bottom nav bar, routing, and deep linking in main.dart
    status: pending
    dependencies:
      - pages
  - id: integration
    content: Integrate all components, add error handling, loading states, and polish UI/UX
    status: pending
    dependencies:
      - navigation
---

# Fesnuk Flutter App - Complete Rewrite Plan

## 1. Project Setup & Dependencies

### Required Packages

- **get**: ^4.6.6 - State management and dependency injection
- **http**: ^1.2.0 - REST API calls
- **cached_network_image**: ^3.3.1 - Image caching and loading
- **image_picker**: ^1.0.7 - Image selection for post creation (supports GIF)
- **photo_view**: ^0.14.0 - Full-screen image viewer with zoom
- **carousel_slider**: ^5.0.0 - Image carousel for post attachments
- **intl**: ^0.19.0 - Date formatting (relative time)
- **uuid**: ^4.3.3 - Generate UUIDs for image filenames
- **emoji_picker_flutter**: ^2.0.0 - Full emoji picker for reactions (or similar)
- **path_provider**: ^2.1.2 - File path utilities for image handling

### Configuration

- Update `pubspec.yaml` with all dependencies
- Configure API base URL (environment-based or config file)
- Set up proper error handling structure

## 2. Architecture: MVVM with GetX

```
lib/
├── main.dart
├── core/
│   ├── config/
│   │   └── api_config.dart
│   ├── constants/
│   │   └── app_constants.dart
│   └── utils/
│       ├── date_formatter.dart
│       └── validators.dart
├── data/
│   ├── models/
│   │   ├── nook_model.dart
│   │   ├── post_model.dart
│   │   └── comment_model.dart
│   ├── repositories/
│   │   └── api_repository.dart
│   └── services/
│       └── api_service.dart
├── presentation/
│   ├── controllers/
│   │   ├── home_controller.dart
│   │   ├── nooks_list_controller.dart
│   │   ├── nook_detail_controller.dart
│   │   ├── post_detail_controller.dart
│   │   └── create_post_controller.dart
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── nooks_list_page.dart
│   │   ├── nook_detail_page.dart
│   │   ├── post_detail_page.dart
│   │   └── create_post_page.dart
│   └── widgets/
│       ├── post_card.dart
│       ├── nook_card.dart
│       ├── comment_item.dart
│       ├── image_carousel.dart
│       └── image_viewer.dart
└── routes/
    └── app_routes.dart
```

## 2.1. Coding Standards & Best Practices

### Component Modularity & Reusability

**Principles**:

- **Single Responsibility**: Each widget/class should have one clear purpose
- **Composition over Inheritance**: Build complex widgets from simple, reusable components
- **Parameterization**: Make widgets flexible through constructor parameters
- **Separation of Concerns**: Keep UI, business logic, and data layers separate

**Widget Design**:

- Extract common patterns into reusable widgets
- Use `const` constructors where possible for performance
- Accept callbacks for user interactions (onTap, onChanged, etc.)
- Provide sensible defaults for optional parameters
- Make widgets stateless when possible, or use GetX controllers for state

**Examples**:

- `PostCard` should be reusable in HomePage, NookDetailPage, etc.
- `ReactionDisplay` should work for both posts and comments
- `ImageCarousel` should handle any list of images
- Form inputs should be extracted into reusable components

### Naming Conventions

**General Rules**:

- Use descriptive, meaningful names that explain purpose
- Prefer clarity over brevity
- Follow Dart/Flutter conventions (PascalCase for classes, camelCase for variables/functions)
- Avoid abbreviations unless universally understood

**Class Names**:

- Widgets: Descriptive noun + type (e.g., `PostCard`, `NookCard`, `ReactionButton`)
- Controllers: Feature name + `Controller` (e.g., `HomeController`, `PostDetailController`)
- Models: Entity name + `Model` (e.g., `PostModel`, `CommentModel`)
- Services: Purpose + `Service` (e.g., `ApiService`, `ImageUploadService`)
- Utils: Purpose + descriptive name (e.g., `DateFormatter`, `ImageHelper`)

**Variable Names**:

- Use descriptive nouns: `postList`, `selectedNook`, `isLoading`, `errorMessage`
- Boolean: Prefix with `is`, `has`, `can`, `should` (e.g., `isLoading`, `hasError`, `canSubmit`)
- Collections: Use plural nouns (e.g., `posts`, `nooks`, `comments`)
- Callbacks: Prefix with `on` (e.g., `onPostTap`, `onReactionSelected`)

**Function Names**:

- Use verbs that describe the action: `fetchPosts()`, `uploadImage()`, `formatDate()`, `validateForm()`
- Getter-like functions: `getPostById()`, `getImageUrl()`
- Boolean returns: `isValid()`, `hasAttachments()`, `canReact()`

**File Names**:

- Match class name: `PostCard` → `post_card.dart`
- Use snake_case for file names
- Group related files in folders

### Comments Strategy

**Comment Only When Necessary**:

- Prefer self-documenting code through good naming
- Add comments for complex business logic or non-obvious decisions
- Document public APIs and important functions
- Explain "why" not "what" (the code shows what, comments explain why)

**When to Comment**:

- Complex algorithms or business logic that isn't immediately obvious
- Workarounds or non-standard implementations
- Important architectural decisions
- API integration details (endpoints, request/response formats)
- Image upload flow (Azure Blob Storage specifics)
- Reaction system implementation (unicode conversion, emoji handling)

**Comment Style**:

- Use Dart doc comments (`///`) for public APIs
- Keep comments concise and focused
- Update comments when code changes
- Avoid redundant comments that just repeat the code

**Example Good Comments**:

```dart
/// Converts unicode string (e.g., "U+1F602") to emoji character.
/// Returns empty string if conversion fails.
String unicodeToEmoji(String unicode) { ... }

// Azure Blob Storage requires x-ms-blob-type header for PUT requests
final headers = {'x-ms-blob-type': 'BlockBlob'};
```

**Example Bad Comments**:

```dart
// Set isLoading to true
isLoading = true;

// This is a list of posts
final List<PostModel> posts = [];
```

### Code Organization

**File Structure**:

- One main class per file
- Related helper functions in the same file if small
- Extract large helper functions to separate utility files
- Group related widgets in subfolders if needed

**Import Organization**:

- Group imports: Dart SDK, Flutter, packages, local imports
- Use relative imports for local files
- Avoid unused imports

**Code Formatting**:

- Run `dart format` before committing
- Follow Dart style guide
- Consistent indentation (2 spaces)
- Maximum line length: 100 characters (soft limit)

## 3. Component Reusability Examples

### Reusable Widgets

**PostCard**:

- Accepts `PostModel` and `onTap` callback
- Can be used in HomePage, NookDetailPage, search results
- Handles all post display logic internally
- Exposes minimal, clear interface

**ReactionDisplay**:

- Accepts `Map<String, int>` reactions and `onReactionTap` callback
- Works for both posts and comments
- Handles unicode to emoji conversion internally
- Only displays reactions with count > 0

**ImageCarousel**:

- Accepts `List<String>` image URLs and `onImageTap` callback
- Reusable for post attachments, comment attachments, any image list
- Handles carousel logic, indicators, tap to fullscreen

**CommentItem**:

- Accepts `CommentModel`, `onReply`, `onReaction` callbacks
- Handles display, replies expansion, reactions
- Can be used for root comments and nested replies

### Reusable Utilities

**DateFormatter**:

- Single function: `formatRelativeTime(String isoDate)`
- Used throughout app for consistent date display
- No side effects, pure function

**ImageHelper**:

- `constructImageUrl(String filename)`: Builds full URL from filename
- `uploadImageToAzure(...)`: Handles Azure upload logic
- Reusable across post creation, comment creation

## 4. Data Models

Based on API response structure:

### NookModel

- `id` (String): Nook identifier (e.g., "anime", "random-chat")
- `name` (String): Display name
- `description` (String): Nook description
- `created_at` (String): ISO timestamp
- `updated_at` (String): ISO timestamp
- Note: No banner image in API, use placeholder for nook cards

### AttachmentModel

- `type` (String): "image"
- `format` (String): File format (e.g., "gif", "png", "jpg")
- `content` (String): Filename (UUID + format, e.g., "a40e02cb-0146-4952-a26c-fb1fd7881e65.gif")
- `original_file_name` (String): Original filename (not used in UI currently)

### PostModel

- `id` (int): Post ID
- `title` (String): Post title
- `content` (String?): Post content (optional)
- `nook_id` (String): Associated nook ID
- `nook_name` (String?): Nook name (in some responses)
- `attachments` (List<AttachmentModel>): Image attachments
- `reactions` (Map<String, int>): Unicode emoji reactions (e.g., {"U+1F44D": 2, "U+1F923": 1})
- `comment_count` (int?): Number of comments (in some responses)
- `created_at` (String): ISO timestamp
- `updated_at` (String): ISO timestamp
- `alias` (String?): User alias if exists, otherwise "Anonymous"

### CommentModel

- `id` (int): Comment ID
- `content` (String): Comment content
- `post_id` (int): Associated post ID
- `parent_id` (int?): Parent comment ID (null for root comments)
- `attachments` (List<AttachmentModel>): Image attachments (if any)
- `reactions` (Map<String, int>): Unicode emoji reactions
- `reply_count` (int): Number of replies
- `path` (String?): Comment path (e.g., "1.2.3" for nested replies)
- `created_at` (String): ISO timestamp
- `updated_at` (String): ISO timestamp
- `alias` (String?): User alias if exists, otherwise "Anonymous"

## 4. Core Components

### API Service Layer

**Base URL**: `https://fesnukberust.azurewebsites.net/api/v1`

**ApiService**: Base HTTP client with error handling

- Handles all HTTP requests
- Error handling and response parsing
- Base URL configuration

**ApiRepository**: Business logic layer for API calls

**API Endpoints**:

**Nooks**:

- `GET /nooks` - Get all nooks
- `GET /nooks/:id` - Get nook by ID

**Posts**:

- `GET /posts` - Get all posts
- `GET /posts/:id` - Get post by ID
- `GET /posts/nook/:id` - Get posts by nook ID
- `POST /posts` - Create new post
- `POST /posts/react` - React to post (action: 1 for up, -1 for down)

**Comments**:

- `GET /comments/post/:post_id` - Get root comments of post
- `GET /comments/:comment_id/replies` - Get comment replies
- `POST /comments` - Create root comment
- `POST /comments/reply` - Reply to comment
- `POST /comments/react` - React to comment (action: 1 for up, -1 for down)

**Image Upload** (Azure Blob Storage):

- `PUT https://fesnukberust.blob.core.windows.net/storage/attachments/:filename?sp=rcl&st=...&se=...&spr=https&sv=...&sr=c&sig=...`
- Header: `x-ms-blob-type: BlockBlob`
- Body: Image as binary
- Filename format: UUID + original format (e.g., `a40e02cb-0146-4952-a26c-fb1fd7881e65.gif`)

**Image Access**:

- Base URL: `https://fesnukberust.blob.core.windows.net/storage/attachments/:filename`
- Example: `https://fesnukberust.blob.core.windows.net/storage/attachments/a40e02cb-0146-4952-a26c-fb1fd7881e65.gif`

### ViewModels (GetX Controllers)

Each page has a corresponding controller:

- **HomeController**: Manages all posts list, refresh, loading states
- **NooksListController**: Manages nooks list, refresh
- **NookDetailController**: Manages single nook data and its posts
- **PostDetailController**: Manages post detail, comments list, comment creation
- **CreatePostController**: Manages post creation form, image selection, image upload to Azure, validation, submission
- **ReactionController** (optional shared): Manages emoji picker and reaction logic for posts/comments

### Utils

- **DateFormatter**: Converts ISO timestamps to relative time ("2 minutes ago", "1 hour ago")
- **Validators**: Form validation for post creation
- **ImageHelper**: Constructs full image URLs from filenames, handles image upload to Azure Blob Storage
- **EmojiHelper**: Converts unicode strings (e.g., "U+1F602") to emoji characters, emoji picker utilities
- **UUIDGenerator**: Generates UUIDs for image filenames

## 6. Pages Implementation

### Home Page (`home_page.dart`)

- AppBar with app title (dark background, emerald accent)
- Pull-to-refresh enabled
- ListView of PostCard widgets with proper spacing
- Loading and error states (minimal design)
- Navigate to PostDetail on tap
- FAB or button to navigate to CreatePost (emerald color)
- Clean, minimal layout with consistent spacing

### Nooks List Page (`nooks_list_page.dart`)

- AppBar with "Nooks" title (dark background, emerald accent)
- Pull-to-refresh enabled
- GridView or ListView of NookCard widgets with proper spacing
- Each card: image, name, description
- Navigate to NookDetail on tap
- Clean grid/list layout with consistent spacing

### Nook Detail Page (`nook_detail_page.dart`)

- Banner image at top (placeholder with emerald accent, rounded bottom corners)
- Nook name (emerald color, prominent) and description section (secondary text)
- Subtle divider (minimal)
- List of posts from this nook (PostCard widgets) with proper spacing
- Pull-to-refresh enabled
- FAB or button to create post in this nook (emerald color)
- Clean, minimal layout

### Post Detail Page (`post_detail_page.dart`)

- Post content section (title in bold, content, images with rounded corners, metadata in secondary text)
- Reaction button and reaction display (emoji with counts, minimal design with emerald accent)
- Comments section below with subtle divider
- Comment input at bottom (for root comments, dark background with emerald accent on focus)
- Pull-to-refresh for comments
- Image carousel with tap to open full-screen viewer
- Each comment shows reply button and reactions (minimal styling)
- Clean, readable layout with proper spacing

### Create Post Page (`create_post_page.dart`)

- Form with minimal, clean design:
  - Nook selector (if accessed from homepage) or pre-filled nook (if from nook detail) - dark dropdown with emerald accent
  - Title field (required, dark background, emerald accent on focus)
  - Content field (optional, multiline, dark background, emerald accent on focus)
  - Image picker (optional, multiple images, supports GIF) - emerald button
  - Image preview grid with remove option (rounded corners, minimal remove button)
  - Submit button (disabled if title empty and no images, emerald when enabled)
- Validation: At least title OR images required (show error in emerald/red)
- Image upload flow:

  1. User selects images
  2. Generate UUID for each image
  3. Upload each image to Azure Blob Storage (PUT request with binary data)
  4. Collect filenames (UUID + format)
  5. Create post with attachment array containing filenames

- Loading state during upload and submission (minimal spinner in emerald)
- Clean, minimal form layout with proper spacing

## 6. Reusable Widgets

### PostCard (`post_card.dart`)

- Title (bold, primary text color)
- Content (if exists, truncated with "read more" in emerald)
- Image carousel (if exists, first image as thumbnail with rounded corners)
- Metadata row: formatted date (secondary text), nook name (tappable, emerald color), alias or "Anonymous" (secondary text)
- Reaction button: Minimal button with emerald accent, opens emoji picker
- Reaction display: Shows emoji buttons with counts (only show reactions with count > 0), minimal styling
- Clean card design with subtle borders, rounded corners
- Tap to navigate to PostDetail

### NookCard (`nook_card.dart`)

- Nook image (placeholder with emerald accent)
- Nook name (emerald color for emphasis)
- Short description (truncated, secondary text color)
- Minimal card design with rounded corners
- Tap to navigate to NookDetail

### ImageCarousel (`image_carousel.dart`)

- Horizontal scrollable carousel
- Tap image to open full-screen viewer
- Dot indicators for current image

### ImageViewer (`image_viewer.dart`)

- Full-screen modal with PhotoView
- Zoom and pan functionality
- Close button
- Image counter (e.g., "1/3")

### CommentItem (`comment_item.dart`)

- Comment content (primary text)
- Alias or "Anonymous" (secondary text, emerald if alias exists)
- Formatted date (secondary text, small)
- Reply button (one-level only, minimal, emerald accent)
- Reaction button: Opens emoji picker (minimal design)
- Reaction display: Shows emoji buttons with counts (only show reactions with count > 0)
- Replies section: Expandable/collapsible replies list with subtle indentation
- Load replies on demand when expanded
- Clean, minimal design with subtle dividers

## 8. Navigation Structure

- Bottom Navigation Bar with 3 tabs (dark background, emerald selected indicator):
  - Home (HomePage)
  - Nooks (NooksListPage)
  - Create Post (CreatePostPage)
- Navigation between pages using GetX navigation
- Deep linking support for nook detail and post detail
- Minimal, clean bottom nav design with emerald accent for selected tab

## 8. State Management Flow

```
User Action → View → Controller → Repository → API Service → Backend
                ↓                                    ↓
            UI Update ← Controller ← Repository ← Response
```

- Controllers extend `GetxController`
- Reactive variables using `.obs`
- Loading states: `isLoading.obs`
- Error handling: `errorMessage.obs`
- Data lists: `posts.obs`, `nooks.obs`, etc.

## 10. Design System & Theme

### Design Principles

- **Minimal**: Clean, uncluttered interfaces
- **Simple**: Straightforward UI patterns
- **Modern**: Contemporary design language
- **Clean**: Plenty of whitespace, clear hierarchy

### Color Scheme

- **Primary Color**: Emerald green (e.g., `Color(0xFF10B981)` or `Colors.emerald`)
- **Dark Mode Only**: No light mode support
- **Background**: Dark gray/black (e.g., `Color(0xFF1A1A1A)` or `Color(0xFF121212)`)
- **Surface**: Slightly lighter dark gray for cards (e.g., `Color(0xFF262626)`)
- **Text**: Light gray/white for primary text, medium gray for secondary
- **Accent**: Emerald green for interactive elements, links, buttons

### Theme Configuration

- Use Material Design 3 dark theme
- Custom color scheme with emerald as primary
- Consistent spacing (8px grid system)
- Subtle borders and dividers
- Minimal shadows (or no shadows for flat design)
- Rounded corners for cards (8-12px radius)

### Typography

- Clean, readable fonts
- Clear hierarchy (headings, body, captions)
- Appropriate font sizes for readability

### Component Styling

- **Cards**: Dark surface with subtle borders, rounded corners
- **Buttons**: Emerald primary color, minimal styling
- **Input Fields**: Dark background with emerald accent on focus
- **Bottom Navigation**: Dark background with emerald selected indicator
- **Reaction Buttons**: Subtle, minimal design with emerald accent
- **Images**: Rounded corners, subtle borders

## 10. Main App Structure

Update `main.dart`:

- Initialize GetX
- Set up routing
- Configure dark theme with emerald primary color
- Bottom navigation bar integration with emerald accent
- Global error handling
- Apply consistent design system throughout

## 12. Implementation Order

1. Setup dependencies and folder structure
2. Create models (after API response structure provided)
3. Implement API service and repository
4. Create utility functions (date formatter, validators)
5. Build reusable widgets (PostCard, NookCard, ImageCarousel, ImageViewer)
6. Implement controllers (ViewModels)
7. Build pages
8. Set up navigation and routing
9. Integrate everything in main.dart
10. Testing and refinement

## Additional Components

### Reaction System

**ReactionDisplay Widget** (Reusable):

- Accepts `reactions` (Map<String, int>) and `onReactionTap` callback
- Converts unicode strings to emoji characters
- Only displays reactions with count > 0
- Minimal, clean design with emerald accent

**ReactionButton Widget** (Reusable):

- Opens emoji picker modal
- Handles reaction selection
- Calls callback with selected unicode and action

**Reaction Logic**:

- Full emoji picker widget (using emoji_picker_flutter or similar package)
- On reaction: Send POST request with unicode (e.g., "U+1F602"), action (1 or -1)
- Update local state optimistically, then sync with API response
- Works for both posts (`/posts/react`) and comments (`/comments/react`)

**Implementation Notes**:

- Unicode format: "U+1F602" stored in API, converted to emoji for display
- Action: 1 for adding reaction, -1 for removing
- Optimistic updates for better UX

### Image Upload Flow

**ImageUploadService** (Reusable Service):

- `uploadImageToAzure(File imageFile)`: Handles single image upload
- `uploadMultipleImages(List<File> imageFiles)`: Handles batch upload
- Returns list of filenames for use in post/comment creation

**Upload Process**:

1. User selects images using `image_picker`
2. Generate UUID for each image using `uuid` package
3. Determine file format from original image
4. Construct filename: `{uuid}.{format}` (e.g., `a40e02cb-0146-4952-a26c-fb1fd7881e65.gif`)
5. Upload to Azure Blob Storage:

   - Method: PUT
   - URL: `https://fesnukberust.blob.core.windows.net/storage/attachments/{filename}?sp=rcl&st=...&se=...&spr=https&sv=...&sr=c&sig=...`
   - Header: `x-ms-blob-type: BlockBlob` (required by Azure)
   - Body: Image binary data

6. After successful upload, include filename in post creation request

**Error Handling**:

- Handle upload failures gracefully
- Show progress for multiple image uploads
- Allow retry on failure

### Comment Replies

**CommentItem Widget** (Reusable):

- Handles both root comments and replies
- Expandable replies section
- Load replies on demand when expanded
- Reply button opens input field below comment

**Reply Logic**:

- One-level replies only (comment can have replies, but replies cannot have nested replies)
- Use `/comments/reply` endpoint with `parent_id`
- Refresh comment list after successful reply
- Show reply count badge on parent comment

## Notes

- **API Base URL**: `https://fesnukberust.azurewebsites.net/api/v1`
- **Image Base URL**: `https://fesnukberust.blob.core.windows.net/storage/attachments/`
- **Error handling**: Show snackbars for API errors
- **Loading states**: Show circular progress indicators
- **Image handling**: Cache images using cached_network_image, show placeholders while loading
- **Form validation**: Real-time validation with error messages
- **Date formatting**: Use intl package for relative time formatting
- **Nook images**: Use placeholder images for nook cards (API doesn't provide images)
- **Alias**: Field exists in API but may not be in all responses, default to "Anonymous" if null
- **GIF support**: Full support for GIF images in attachments
- **Reaction unicode format**: Store and display as "U+1F602" format, convert to emoji for display
- **Design**: Minimal, simple, modern, clean design with dark mode only
- **Color scheme**: Emerald green primary color (`Color(0xFF10B981)` or `Colors.emerald`), dark backgrounds
- **Theme**: Material Design 3 dark theme with custom emerald color scheme
- **Code Quality**: 
  - All components must be modular and reusable
  - Use descriptive, meaningful naming (prefer good names over excessive comments)
  - Add comments only for complex logic, important decisions, or non-obvious implementations
  - Follow Dart/Flutter naming conventions
  - Extract common patterns into reusable widgets and utilities
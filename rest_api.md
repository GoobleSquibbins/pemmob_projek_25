Base URL : https://fesnukberust.azurewebsites.net/api/v1

Nooks

1. Get ALL

- Endpoint : /nooks
- Response Example :

```json
{
  "data": [
    {
      "created_at": "2025-10-06T05:38:11.643117",
      "description": "The central hub for completely off-topic and unpredictable discussions. The heart of the chaos.",
      "id": "random-chat",
      "name": "Random",
      "updated_at": "2025-10-06T05:38:11.643117"
    },
    {
      "created_at": "2025-10-06T05:38:11.643117",
      "description": "A no-holds-barred forum for discussing global current events, political theories, and news from every angle.",
      "id": "world-politics",
      "name": "Politics & News",
      "updated_at": "2025-10-06T05:38:11.643117"
    }
  ],
  "message": "Nooks retrieved successfully",
  "status": 200
}
```

2. Get Nook By ID

- Endpoint : /nooks/:id
- Response Example :

```json
{
  "data": {
    "created_at": "2025-10-03T23:50:52.002354",
    "description": "All about anime culture",
    "id": "anime",
    "name": "Anime",
    "updated_at": "2025-10-03T23:50:52.002354"
  },
  "message": "Nook retrieved successfully",
  "status": 200
}
```

Posts

1. Get All Posts

- Endpoint : /posts
- Response Example :

```json
{
  "data": [
    {
      "attachments": [
        {
          "content": "a40e02cb-0146-4952-a26c-fb1fd7881e65.gif",
          "format": "gif",
          "original_file_name": "evernight-chibi.gif",
          "type": "image"
        }
      ],
      "content": "Lorem Ipsum",
      "created_at": "2025-10-04T00:21:55.454712",
      "id": 1,
      "nook_id": "anime",
      "reactions": {
        "U+1F44D": 2,
        "U+1F44E": 0,
        "U+1F923": 1
      },
      "title": "Dummy Post",
      "updated_at": "2025-10-04T00:21:55.454712"
    }
  ],
  "message": "Posts retrieved successfully",
  "status": 200
}
```

2. Get Post By ID

- Endpoint : /posts/:id
- Respone Example :

```json
{
  "data": {
    "attachments": [
      {
        "content": "a40e02cb-0146-4952-a26c-fb1fd7881e65.gif",
        "format": "gif",
        "original_file_name": "evernight-chibi.gif",
        "type": "image"
      }
    ],
    "content": "Lorem Ipsum dolor sit amet",
    "created_at": "2025-10-05T07:01:33.654359",
    "id": 4,
    "nook_id": "anime",
    "reactions": {
      "U+1F44D": 2,
      "U+1F44E": 0,
      "U+1F923": 1
    },
    "title": "Dummy Post",
    "updated_at": "2025-10-05T07:01:33.654359"
  },
  "message": "Post retrieved successfully",
  "status": 200
}
```

3. Get Posts by Nook id
   Endpoint : /posts/nook/:id
   Response example :

```json
{
  "data": [
    {
      "attachments": [],
      "comment_count": 0,
      "content": "Jadi tak?",
      "created_at": "2025-10-07T01:32:26.693154",
      "id": 10,
      "nook_id": "random-chat",
      "nook_name": "Random",
      "reactions": {
        "U+1F44D": 2,
        "U+1F44E": 0,
        "U+1F923": 1
      },
      "title": "Harusnya diatas si bang",
      "updated_at": "2025-10-07T02:39:47.835909"
    },
    {
      "attachments": [],
      "comment_count": 0,
      "content": "Ya gitu",
      "created_at": "2025-10-07T01:07:44.680391",
      "id": 9,
      "nook_id": "random-chat",
      "nook_name": "Random",
      "reactions": {
        "U+1F97A": 0,
        "U+2764": 1
      },
      "title": "Test refresh nya euy",
      "updated_at": "2025-10-07T02:41:18.902298"
    }
  ],
  "message": "Posts retrieved successfully",
  "status": 200
}
```

4. Create New Post

- Endpoint : /posts (POST method)
- Request Example :
  Create new Post with attachment

```json
{
  "title": "Dummy Post",
  "content": "Lorem Ipsum dolor sit amet",
  "nook_id": "anime",
  "attachment": [
    {
      "type": "image",
      "format": "gif",
      "content": "a40e02cb-0146-4952-a26c-fb1fd7881e65.gif",
      "original_file_name": "evernight-chibi.gif"
    }
  ]
}
```

- Response Example :

```json
{
  "data": {
    "attachments": [],
    "content": "Lorem Ipsum",
    "created_at": "2025-10-04T00:21:55.454712",
    "id": 1,
    "nook_id": "anime",
    "title": "Dummy Post",
    "updated_at": "2025-10-04T00:21:55.454712"
  },
  "message": "Post created successfully",
  "status": 201
}
```

Create new Post without Attachment

```json
{
  "title": "Dummy Post",
  "content": "Lorem Ipsum",
  "nook_id": "anime"
}
```

Response example :

```json
{
  "data": {
    "attachments": [
      {
        "type": "image",
        "format": "gif",
        "content": "a40e02cb-0146-4952-a26c-fb1fd7881e65.gif",
        "original_file_name": "evernight-chibi.gif"
      }
    ],
    "content": "Lorem Ipsum",
    "created_at": "2025-10-04T00:21:55.454712",
    "id": 1,
    "nook_id": "anime",
    "title": "Dummy Post",
    "updated_at": "2025-10-04T00:21:55.454712"
  },
  "message": "Post created successfully",
  "status": 201
}
```

5. Reacting Post (UP)
- Endpoint : /posts/react (POST method)
- Request :
```json
{
    "post_id": 1,
    "unicode": "U+1F923",
    "action": 1
}
```
- Response :
```json
{
    "data": {
        "attachments": [],
        "content": "Lorem Ipsum",
        "created_at": "2025-10-04T00:21:55.454712",
        "id": 1,
        "nook_id": "anime",
        "reactions": {
            "U+1F923": 1
        },
        "title": "Dummy Post",
        "updated_at": "2025-10-05T06:29:20.665728"
    },
    "message": "Post reacted successfully",
    "status": 200
}
```
6. Reacting Post (DOWN)
- Endpoint : /posts/react (POST method)
- Request :
```json
{
    "post_id": 1,
    "unicode": "U+1F923",
    "action": -1
}
```
- Response :
```json
{
    "data": {
        "attachments": [],
        "content": "Lorem Ipsum",
        "created_at": "2025-10-04T00:21:55.454712",
        "id": 1,
        "nook_id": "anime",
        "reactions": {
            "U+1F923": 1
        },
        "title": "Dummy Post",
        "updated_at": "2025-10-05T06:29:20.665728"
    },
    "message": "Post reacted successfully",
    "status": 200
}
```

Comments
1. Get Root comments of post
- Endpoint : /comments/post/:post_id
- Response :
```json
{
    "data": [
        {
            "attachments": [],
            "content": "Test comment coy",
            "created_at": "2025-10-05T18:31:40.574927",
            "id": 1,
            "parent_id": null,
            "post_id": 1,
            "reactions": {},
            "reply_count": 0,
            "updated_at": "2025-10-05T18:31:40.574927"
        }
    ],
    "message": "Root comments retrieved successfully",
    "status": 200
}
```
2. Get comment replies
- Endpoint : /comments/:comment_id/replies
- Response :
```json
{
    "data": [
        {
            "content": "Test reply comment coy part 2",
            "created_at": "2025-10-05T11:30:24.255701Z",
            "id": 3,
            "parent_id": 2,
            "path": "1.2.3",
            "post_id": 1,
            "reply_count": 0,
            "updated_at": "2025-10-05T11:30:24.258365Z"
        }
    ],
    "message": "Replies retrieved successfully",
    "status": 200
}
```

3. Create root comment (direct child to post)
- Endpoint : /comments (POST method)
- Request : 
```json
{
    "post_id": 1,
    "content": "Test comment coy",
    "attachments": []
}
```
- Response :
```json
{
    "data": {
        "attachments": [],
        "content": "Test comment coy",
        "created_at": "2025-10-05T18:31:40.574927",
        "id": 1,
        "parent_id": null,
        "post_id": 1,
        "reactions": {},
        "reply_count": 0,
        "updated_at": "2025-10-05T18:31:40.574927"
    },
    "message": "Root comment created successfully",
    "status": 201
}
```

4. Reply Comment
- Endpoint : /comments/reply (POST method)
- Request : 
```json
{
    "post_id": 1,
    "content": "Test reply comment coy",
    "parent_id": 1
}
```
- Response :
```json
{
    "data": {
        "attachments": [],
        "content": "Test reply comment coy",
        "created_at": "2025-10-05T18:35:01.306452",
        "id": 2,
        "parent_id": 1,
        "post_id": 1,
        "reactions": {},
        "reply_count": 0,
        "updated_at": "2025-10-05T18:35:01.306452"
    },
    "message": "Reply comment created successfully",
    "status": 201
}
```

5. React Comment (UP = 1, DOWN = -1)
- Endpoint : /comments/react (POST method)
- Request : 
```json
{
    "comment_id": 1,
    "unicode": "U+1F602",
    "action": 1
}
```
- Response :
```json
{
    "data": {
        "attachments": [],
        "content": "Test comment coy",
        "created_at": "2025-10-05T18:31:40.574927",
        "id": 1,
        "parent_id": null,
        "post_id": 1,
        "reactions": {
            "U+1F602": 1
        },
        "reply_count": 1,
        "updated_at": "2025-10-05T18:36:36.350955"
    },
    "message": "Comment reacted successfully",
    "status": 200
}
```


For Image There using Azure Storage :
1. Upload Image : 
METHOD : PUT
FULL URL : https://fesnukberust.blob.core.windows.net/storage/attachments/:filename?sp=rcl&st=2025-10-05T06:39:13Z&se=2045-10-05T14:54:13Z&spr=https&sv=2024-11-04&sr=c&sig=ujGh09%2BexMGTeOwF9XEoFgOOBQzizcr3ouJHKyAnOJ8%3D
HEADER : 
x-ms-blob-type: BlockBlob
BODY: Image as binary

For filename using UUID + original image format. Like a40e02cb-0146-4952-a26c-fb1fd7881e65.gif
We also support gif.

2. Access Image :
https://fesnukberust.blob.core.windows.net/storage/attachments/:filename
For example :
https://fesnukberust.blob.core.windows.net/storage/attachments/a40e02cb-0146-4952-a26c-fb1fd7881e65.gif
# bbn-json-hs

blog.bouzuya.net json api using haskell.

- wai
- warp
- aeson
- http-conduit

## Usage

```bash
$ stack exec bbn-json-hs-exe
```

## API

- `/` ... all entries
- `/{yyyy}/{mm}/{dd}/` ... an entry

### `/`

```bash
$ curl 'http://localhost:3000/' | jq .
[
  {
    "date": "2017-01-01",
    "title": "タイトル"
  }
]
```

### `/{yyyy}/{mm}/{dd}/`

```bash
$ curl 'http://localhost:3000/2017/01/01/' | jq .
{
  "date": "2017-01-01",
  "title": "タイトル",
  "html": "<p>Hello</p>"
}
```

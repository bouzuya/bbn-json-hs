# bbn-json-hs

blog.bouzuya.net json api using haskell.

- wai
- warp
- aeson
- http-conduit

## Usage

### Development

```bash
$ stack exec bbn-json-hs-exe
```

### Deployment

```bash
$ ./scripts/docker-build.sh
$ # use `-p ...:3000` or `export PORT=...`
$ docker run -p 3000:3000 bouzuya/bbn-json-hs-exe:latest
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

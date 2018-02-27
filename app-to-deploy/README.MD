
# Lancer l'API
```
node index.js

# Choisir le path de l'url
docker run -e "URL_PATH=/xebia" xebia-france/dummy
```

# Appeler l'API

```curl
# Image
curl -XGET http://localhost:3000/static/aws.png

# Lister les images uploadées
curl -XGET http://localhost:3000/api/images

# Uploader une image
curl -XPOST -H "Content-Type: application/json" http://localhost:3000/api/images -d '{
    "url": "https://i.kinja-img.com/gawker-media/image/upload/s--vZF4-JZr--/c_scale,fl_progressive,q_80,w_800/mbul93zcvchtgz756rqc.jpg",
    "name": "avion.png"
}'
```
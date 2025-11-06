# Utilise une image Nginx légère comme BASE
FROM nginx:alpine

# Copie tous les fichiers du site dans le dossier web de Nginx
COPY . /usr/share/nginx/html

# Expose le port 80 (standard pour les sites web)
EXPOSE 80

# Lance Nginx en mode foreground
CMD ["nginx", "-g", "daemon off;"]
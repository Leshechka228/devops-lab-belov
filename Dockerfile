FROM nginx:alpine

COPY index.html /usr/share/nginx/html/
COPY nginx-docker.conf /etc/nginx/conf.d/default.conf

EXPOSE 8181

CMD ["nginx", "-g", "daemon off;"]

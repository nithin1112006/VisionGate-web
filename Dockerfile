FROM nginx:alpine
COPY nginx-render.conf /etc/nginx/conf.d/default.conf
COPY web_build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

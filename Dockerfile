FROM nginx:latest

# Copia os arquivos da aplicação para o diretório padrão do Nginx
#COPY ./html /usr/share/nginx/html

# Copia um arquivo de configuração customizado (opcional)
# COPY ./nginx.conf /etc/nginx/nginx.conf

# Expõe a porta padrão do Nginx
EXPOSE 80

# Comando padrão para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]

#!/bin/bash

# Дефиниране на името на Docker образа
DOCKER_IMAGE_NAME="react-app-container"

# Проверка дали Docker е инсталиран
if ! [ -x "$(command -v docker)" ]; then
  echo "Docker не е инсталиран. Моля, инсталирайте Docker, за да продължите."
  exit 1
fi

# Проверка дали Dockerfile вече съществува
if [ -f Dockerfile ]; then
  echo "Dockerfile вече съществува в тази директория. Прекратяване на операцията."
  exit 1
fi

# Създаване на Dockerfile
cat > Dockerfile <<EOL
# Използване на официален Node.js образ като основен образ
FROM node:14

# Задаване на работна директория в контейнера
WORKDIR /usr/src/app

# Копиране на package.json и package-lock.json в контейнера
COPY package*.json ./

# Инсталиране на зависимостите на приложението
RUN npm install

# Копиране на изходния код на приложението
COPY . .

# Изграждане на React приложението за продукция
RUN npm run build

# Излагане на порт, на който приложението ще работи
EXPOSE 3000

# Стартиране на приложението
CMD ["npm", "start"]
EOL

echo "Създаден е Dockerfile."

# Изграждане на Docker образа
docker build -t $DOCKER_IMAGE_NAME .

# Проверка дали изграждането е успешно
if [ $? -eq 0 ]; then
  echo "Docker образ $DOCKER_IMAGE_NAME е успешно изграден."
  echo "Можете да стартирате приложението със следната команда:"
  echo "docker run -p 8080:3000 $DOCKER_IMAGE_NAME"
else
  echo "Изграждането на Docker образа се провали. Моля, проверете за грешки."
fi


### Listar 

docker ps



####  Iniciar dentro do contexto

docker-compose up -d


#########   CRIAR IMAGEM COM DOCKER FILE "Dockerfile.frontend.homologacao"  ##############

docker build -force-recreate  -t teste -f Dockerfile.frontend.homologacao . 



############ INICIAR container "teste" expondo portas ###############

docker run -itd --name teste -p8000:8000 -p9080:4200  teste 


#############  EXCLUIR container "teste"  ####

docker rm -f teste



############ VER LOGS contatiner "teste" ##############

docker logs teste  -f


################  Executar container "teste" mapeando pasta local 

docker run -itd --name teste -u root -v "${PWD}/:/api" -w /api debian 


######  INSERIR TAG na imagem do container ######

docker tag nomecontainer  imagem:latest
 
 ######  UPLOAD da imagem do container 
 
 docker push dockerhub.com.br:latest
 docker push dockerhub.com.br
 
 #### executar container ####
 docker run -itd --restart=always --name nomecontainer  -p5080:5080 imagemcontainer



####  Parar container


 docker-compose down


###########  LIMPAR TUDO ###############

docker system prune --all 


###########  LIMPAR VOLUME ###############
docker volume prune 

docker system prune --volumes -a


DOCKER SERVICE


Na pasta do projeto EXECUTAR

docker stack deploy --compose-file docker-compose.yml nomedocontainerasercriado


LISTAR SERVICES CRIADOS DO DEPLOY

docker service ls





## ACUNETIX SCANNER ##




https://hub.docker.com/r/leandrobarata/acuscanner


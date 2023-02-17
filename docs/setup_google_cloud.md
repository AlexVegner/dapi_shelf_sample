# Setup Google Cloud
TBD 

## With VM instances

1. Create VM with (Ubuntu 18.04.6 LTS) 0.25 shared core + 2gb RAM + standard 10Gb drive

2. Generate ssh key 
```sh 
ssh-keygen -t rsa -f ~/.ssh/daylog_rsa -C ${USERNAME} -b 2048
```

3. Add ssh key if not default 
```sh
ssh-add ~/.ssh/daylog_rsa
```

4. Copy to clipboard
```sh
pbcopy < ~/.ssh/daylog_rsa.pub
```

5. Add ssh key to vm instance 
  - open vm instance
  - edit instance
  - copy ssh fingerprint from clipboard

6. Connect to ssh: 
```sh
ssh ssh ${USERNAME}@${PUBLIC_IP} 
```

7. Install docker
```sh
sudo snap install docker
```

8. Install docker compose
```sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

9. Set permission for docker compose
```sh
sudo chmod +x /usr/local/bin/docker-compose
```

10. Check docker-compose version
```sh
docker-compose --version
```

11. Create src/ folder 
```sh
mkdir src && \
cd src/
```

12. Clone project 
```sh
git clone https://github.com/AlexVegner/dapi_shelf_sample.git && \
cd dapi_shelf_sample
```

13. Deploy server and postgress
```sh
sudo docker-compose up -d
```

14. Check server 
```sh 
open http://${PUBLIC_IP}
```
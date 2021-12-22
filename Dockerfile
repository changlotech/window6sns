FROM python:3.9.0

# 컨테이너 안에서는 루트계정으로 모든명령을 실행하기 때문에 루트계정에  볼더를 만들어준다.
RUN mkdir /root/.ssh/

# 이미지를 가지는 사람은 private key 또한 입수할수 있다.
# 우분투게정(호스트계정)의 id_rsa 를   도커컨테이너의 경로에 복사 붙혀넣기한다 id_rsa 키파일을
ADD ./.ssh/id_rsa /root/.ssh/id_rsa

# 뭔가 작업을 해야하는데 권한이 없어서 못할 수 있기때문에 권한을 주는 명령어
RUN chmod 600 /root/.ssh/id_rsa

# 깃헙에 권한 주기
RUN touch /root/.ssh/known_hosts

RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

WORKDIR /home/

RUN echo "ababab"

RUN git clone git@github.com:edit11020211/window4sns.git

WORKDIR /home/window4sns/

RUN pip install -r requirements.txt

RUN pip install gunicorn

RUN pip install mysqlclient

EXPOSE 8000

CMD ["bash", "-c", "python manage.py collectstatic --noinput --settings=pragmatic.settings.deploy && python manage.py migrate --settings=pragmatic.settings.deploy && gunicorn pragmatic.wsgi --env DJANGO_SETTINGS_MODULE=pragmatic.settings.deploy --bind 0.0.0.0:8000"]
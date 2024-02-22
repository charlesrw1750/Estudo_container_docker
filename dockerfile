# Usa a imagem base do OpenJDK com Alpine
FROM docker.io/openjdk:8u201-jdk-alpine3.9

# Instalação de dependências
RUN apk --no-cache add \
    wget \
    git

# Versão do Maven
ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

# Instalação do Maven
RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && rm apache-maven-$MAVEN_VERSION-bin.tar.gz \
    && mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

# Criação de usuário e diretório de trabalho
RUN addgroup -S notes && adduser -S notes -G notes
USER notes:notes
WORKDIR /opt/note

# Clone do projeto e construção com Maven
RUN git clone https://github.com/callicoder/spring-boot-mysql-rest-api-tutorial.git /opt/note
WORKDIR /opt/note
RUN mvn clean package -Dmaven.compiler.target=1.8 -Dmaven.compiler.source=1.8 -Dmaven.test.skip=true

# Copia do arquivo JAR resultante
ARG JAR_FILE=target/easy-notes-1.0.0.jar
RUN cp $JAR_FILE /opt/note/easy-note.jar

# Comando de execução do JAR
ENTRYPOINT ["java", "-jar", "/opt/note/easy-note.jar"]

#include <sys/socket.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 5000
#define BUF_SIZE 256

int client(const char* filename)
{
    /* Create file where data will be stored */
    FILE *fp = fopen(filename, "ab");
    if(NULL == fp)
    {
        printf("Error opening file");
        return 1;
    }

    /* Create a socket first */
    int sockfd = 0;
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0))< 0)
    {
        printf("\n Error : Could not create socket \n");
        return 1;
    }

    /* Initialize sockaddr_in data structure */
    struct sockaddr_in serv_addr;
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT); // port
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

    /* Attempt a connection */
    if(connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr))<0)
    {
        printf("\n Error : Connect Failed \n");
        return 1;
    }

    /* Receive data in chunks of BUF_SIZE bytes */
    int bytesReceived = 0;
    char buff[BUF_SIZE];
    memset(buff, '0', sizeof(buff));
    while((bytesReceived = read(sockfd, buff, BUF_SIZE)) > 0)
    {
        printf("Bytes received %d\n",bytesReceived);
        fwrite(buff, 1,bytesReceived,fp);
    }

    if(bytesReceived < 0)
    {
        printf("\n Read Error \n");
    }

    return 0;
}

int main(int argc, char** argv)
{
    if (argc == 2)
    {
        const char* filename = argv[1];
        return client(filename);
    }
    else
    {
        printf("Invalid number of argument, usage is %s [FILENAME]\n",argv[0]);
    }
    return 1; // Something went wrong
}

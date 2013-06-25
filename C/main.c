//  main.c
//  project7

#include <stdio.h>
#include <stdlib.h>
#define ARRAY_SIZE 100000

struct point {
    double x;
    double y;
    struct point *next;
};
typedef struct point point;

struct polygon{
    point points[ARRAY_SIZE];
    int size;
    struct polygon *next;
};
typedef struct polygon polygon;

struct adjacentList{
    char* name;
    struct adjacentList *next;
};
typedef struct adjacentList adjacentList;

struct region {
    char* name;
    polygon p;
    struct adjacentList* first;
    struct adjacentList* last;
    struct region *next;
};
typedef struct region region;

int numRegions = 0;
region regions[500];

enum Boolean {True = 1, False = 0};
typedef enum Boolean Boolean;

struct region *head = NULL;
struct region *curr = NULL;

void processLine(char *line);
void removeSpaces(char* source);
char getName(char* source);
void print_list(void);
void addPoints(float* points);
struct region* createList(char* ptr);
struct region* addToList(char* ptr);
Boolean Is_Adjacent_Region(struct region *r1, struct region *r2);
Boolean Intersects_Line(struct point *a1, struct point *a2, struct point *b1, struct point *b2);

int main(int argc, char * argv[])
{
    char line[1024];
    FILE *fp = fopen(argv[1],"r");
    
    if( fp == NULL ) {
        return 0;
    }
    
    while( fgets(line,1024,fp) ) {
        processLine(line);
    }

    struct region * previous = head;
    struct region * temp = head;
    struct region * iterator;
    
    while(temp != NULL){
        if(previous != temp){
            iterator = temp;
            while (iterator != NULL) {
                Boolean adj = Is_Adjacent_Region(iterator, previous);
                if (adj) {
                    adjacentList * newNode1 = malloc(sizeof(adjacentList));
                    newNode1->name = previous->name;
                    newNode1->next = NULL;
                    if(iterator->last == NULL) {
                        iterator->first = newNode1;
                        iterator->last = newNode1;

                    }
                    else {
                        iterator->last->next = newNode1;
                        iterator->last = newNode1;
                    }
                    
                    adjacentList * newNode2 = malloc(sizeof(adjacentList));
                    newNode2->name = iterator->name;
                    newNode2->next = NULL;
                    if(previous->last == NULL){
                        previous->first = newNode2;
                        previous->last = newNode2;
                    }
                    else {
                        previous->last->next = newNode2;
                        previous->last = newNode2;
                    }
                }
                iterator = iterator->next;
            }
            previous = temp;
        }
        temp = temp->next;
    }

    region* t = head;
    while(t != NULL){
        adjacentList* iter = t->first;
        printf("%s: ", t->name);
        while (iter->next != NULL) {
            printf ("%s, ", iter->name);
            iter = iter->next;
        }
        printf ("%s ", iter->name);
        printf("\n");
        t = t->next;
    }
    //printf("%s", head->name);
    //print_list();
    return 1;
}

void processLine(char* line){
    int index;
    index = 0;
    char holder[30];
    
    int i;
    for (i = 0; i < 30; i++){ holder[i] = '\0';}
    
    removeSpaces(line);
    if(line[0] == '{'){
        index++;
        
        while(line[index] != ',')
        {
            holder[index-1] = line[index];
            index++;
        }
    
        if(head == NULL){
            createList(holder);
        }
        else{
            addToList(holder);
        }
        
        //printf("%s", curr->name);
    }
    
    while(line[index] != '\0'){
        //skip comma
        if(line[index] == ','){
            index++;
        }
        //skip
        else if(line[index] == '['){
            index++;
        }
        else if(line[index] == '('){
            index++;
            char xBuffer[100];
            
            for (i=0; i<100;++i) {xBuffer[i]='\0';}
            
            int size;
            size = 0;

            //x value
            while(line[index] != ','){
                xBuffer[size] = line[index];
                index++;
                size++;
            }
            double xPoint=(atof(xBuffer));
            curr->p.points[curr->p.size].x= xPoint;
            
            index++;
            
            char yBuffer[100];
            
            for (i=0; i<100;++i) {yBuffer[i]='\0';}

            size = 0;

            //y value
            while(line[index] != ')'){
                yBuffer[size] = line[index];
                index++;
                size++;
            }
            double yPoint=(atof(yBuffer));
            curr->p.points[curr->p.size].y= yPoint;
            curr->p.size++;
            
            //printf("%s\n", curr->name);
            //printf("(%lf, %lf)\n", curr->p.points[0].x, curr->p.points[0].y);
        }
        else{
            index++;
        }
        
    }
    
   // printf("%s", line);
}

struct region* createList(char * holder)
{
    struct region *ptr = (struct region*)malloc(sizeof(struct region));
    char *temp = (char *) malloc (sizeof(char) * 30);
    
    int i;
    for(i = 0; i < 30; i++){
        *temp = *holder;
        temp++;
        holder++;
    }
    holder-=30;
    temp -= 30;
        
    ptr->name = temp;
    ptr->next = NULL;
    ptr->p.size = 0;
    ptr->first = NULL;
    ptr->last = NULL;
    
    head = curr = ptr;

    return ptr;
}

struct region* addToList(char * holder)
{
    char *temp = (char *) malloc (sizeof(char) * 30);

    int i;
    for(i = 0; i < 30; i++){
        *temp = *holder;
        temp++;
        holder++;
    }
    holder -=30;
    temp -= 30;
    
    struct region *ptr = (struct region*)malloc(sizeof(struct region));
    ptr->name = temp;
    ptr->next = NULL;
    ptr->p.size = 0;
    ptr->first = NULL;
    ptr->last = NULL;

    curr->next = ptr;
    curr = ptr;
    
    return ptr;
}


void removeSpaces(char* source)
{
    char* i = source;
    char* j = source;
    
    while(*j != 0)
    {
        *i = *j++;
        if(*i != ' ')
            i++;
    }
    *i = 0;
}

Boolean Is_Adjacent_Region(struct region *r1, struct region *r2)
{
    int i;
    int j;
    for(i = 0; i < r1->p.size-1; i++){
        for(j = 0; j < r2->p.size-1; j++){
            //printf("%lf,%lf\n", r1->p.points[i].x, r1->p.points[j].y);
            if(Intersects_Line(&r1->p.points[i], &r1->p.points[i+1], &r2->p.points[j], &r2->p.points[j+1]) == True)
                return True;
        }
    }
    
    return False;
}

Boolean Intersects_Line(struct point *a1, struct point *a2, struct point *b1, struct point *b2){
    
    double aSlope;
    double bSlope;
    double tempAHelper;
    double tempBHelper;
    double tempA;
    double tempB;
    double xi;
    double yi;
    
    aSlope = ((a2->y)-(a1->y))/((a2->x)-(a1->x));
    bSlope = ((b2->y)-(b1->y))/((b2->x)-(b1->x));
    
    if(aSlope == bSlope){
        if(((a2->x == b2->x && a2->y == b2->y) && (a1->x == b1->x && a1->y == b1->y)) || ((a2->x == b1->x && a2->y == b1->y) && (a1->x == b2->x && a1->y == b2->y))){
            return True;
        }
        else{
            return False;
        }
    }
    else{
        
        if((a2->x) - (a1->x) == 0){
            tempAHelper = a1->x;
        }
        else{
            tempAHelper = ((a2->y)-(a1->y))/((a2->x)-(a1->x));
        }
        
        if((b2->x) - (b1->x) == 0){
            tempBHelper = b1->x;
        }
        else{
            tempBHelper = ((b2->y)-(b1->y))/((b2->x)-(b1->x));
        }
        
        tempA = (a1->y)-tempAHelper*(a1->x);
        tempB = (b1->y)-tempBHelper*(b1->x);
        
        xi = -(tempA-tempB)/(tempAHelper-tempBHelper);
        yi = tempA+tempAHelper*xi;
        
        if((((a1->x)-xi)*(xi-(a2->x)) >= 0) && (((b1->x)-xi)*(xi-(b2->x)) >= 0) && (((a1->y)-yi)*(yi-(a2->y)) >= 0) && (((b1->y)-yi)*(yi-(b2->y)) >= 0)){
            
            return True;
        }
        
        return False;
    }

    return False;
}

void print_list(void)
{
    struct region *ptr = head;
    
    printf("\n -------Printing list Start------- \n");
    while(ptr != NULL)
    {
        printf("\n [%s] \n",ptr->name);
        ptr = ptr->next;
    }
    printf("\n -------Printing list End------- \n");
    
    return;
}
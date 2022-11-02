#include <stdio.h>
int x = 1;
int overflows = 0;
int underflows = 0;
int calls = 1;
void call (){
	if(x < 8)
		x++;
	else {
		overflows++;
	}
}
void ret (){
	if(x > 2)
		x--;
	else {
		underflows++;
	}
}
int ack3way(int m, int n, int p)
{
    calls++;
    if(p==0)
        return m+n;
    if(n==0 && p==1)
        return 0;
    if(n==0 && p==2)
        return 1;
    if(n==0)
        return m;
    else{
        call();
        int mv = ack3way(m,n-1,p);
        ret();
        call();
        int rv = ack3way(m,mv,p-1);
        ret();
        return rv;
    }
}
int main()
{
    call();
    printf("Result: %d\n", ack3way(2,3,3));
    x--;       
    printf("Oveflows: %d\nUnderflows: %d\nCurrent Register banks: %d\nCalls: %d\n", overflows, underflows, x, calls);
    return 0;
}
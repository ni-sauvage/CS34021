#include <stdio.h>
int x = 1;              // Current active register banks. As we start in main, there is 1 active register bank
int overflows = 0;      // No overflows yet
int underflows = 0;     // No underflows yet
int calls = 0;          // No calls to ack3way yet

void call (){           // function to be called whenever another function that is being simulated is called
	if(x < 8)           // If we have less than 8 currently active register banks, then
		x++;            // Increase currently active register banks
	else                // Otherwise
		overflows++;    // We have an overflow
}

void ret (){            // function to be called whenever another function that is being simulated returns
	if(x > 2)           // If we have more than 2 register banks currently active
		x--;            // Decrement currently active register banks as we have returned
	else                // Otherwise
		underflows++;   // We have an underflow and must fetch from stack
}

int ack3way(int m, int n, int p)
{
    calls++;                        // There has been a call to ack3way, increment counter
    if(p==0)
        return m+n;
    if(n==0 && p==1)
        return 0;
    if(n==0 && p==2)
        return 1;
    if(n==0)
        return m;
    else{                          
        call();                     // Call call() function, will increment register banks and detect overflow 
        int mv = ack3way(m,n-1,p);  // call ack3way
        ret();                      // call return function as ack3way has returned, will decrement register banks and detect underflow
        call();                     // Call call() function, will increment register banks and detect overflow
        int rv = ack3way(m,mv,p-1); // call ack3way
        ret();                      // call return function as ack3way has returned, will decrement register banks and detect underflow
        return rv;                  
    }
}
int main()
{
    call();                                  // Call call() function, will increment register banks and detect overflow 
    printf("Result: %d\n", ack3way(2,3,3));  // print result from function
    x--;                                     // There will be 2 currently active register banks, but we do not want to call ret() as this would detect underflow, which is not correct: In main, there is only 1 active register bank.
    printf("Oveflows: %d\nUnderflows: %d\nCurrent Register banks: %d\nCalls: %d\n", overflows, underflows, x, calls); //print results


    x = 1;              // Current active register banks. As we start in main, there is 1 active register bank
    overflows = 0;      // No overflows yet
    underflows = 0;     // No underflows yet
    calls = 0;          // No calls to ack3way yet
    call();                                 // Call call() function, will increment register banks and detect overflow  
    printf("Result: %d\n", ack3way(1,8,8)); // print result from function
    x--;                                    // There will be 2 currently active register banks, but we do not want to call ret() as this would detect underflow, which is not correct: In main, there is only 1 active register bank.
    printf("Oveflows: %d\nUnderflows: %d\nCurrent Register banks: %d\nCalls: %d\n", overflows, underflows, x, calls);
    
    
    x = 1;              // Current active register banks. As we start in main, there is 1 active register bank
    overflows = 0;      // No overflows yet
    underflows = 0;     // No underflows yet
    calls = 0;          // No calls to ack3way yet
    call();                                  // Call call() function, will increment register banks and detect overflow
    printf("Result: %d\n", ack3way(10,5,2)); // print result from function
    x--;                                     // There will be 2 currently active register banks, but we do not want to call ret() as this would detect underflow, which is not correct: In main, there is only 1 active register bank.
    printf("Oveflows: %d\nUnderflows: %d\nCurrent Register banks: %d\nCalls: %d\n", overflows, underflows, x, calls);
    return 0;
}
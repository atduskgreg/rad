#include <WProgram.h>

void loop();
void setup();
int main();

void setup() {
	pinMode(13, OUTPUT);
}

int main() {
	init();
	setup();
	for( ;; ) { loop(); }
	return 0;
}
    
void loop() {
	digitalWrite( 13, HIGH );
	delay( 500 );
	digitalWrite( 13, LOW );
	delay( 500 );
}
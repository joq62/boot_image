all:
#	service
	rm -rf  ebin/* src/*.beam *.beam test_src/*.beam test_ebin;
	rm -rf *.dir;
	rm -rf  *~ */*~  erl_cra*;
#	app
#	cp src/*.app ebin;
	erlc -I include -o ebin src/*.erl;
	echo Done
unit_test:
	rm -rf ebin/* src/*.beam *.beam test_src/*.beam test_ebin;
	rm -rf *.dir;
	rm -rf  *~ */*~  erl_cra*;
	mkdir test_ebin;
#	app
#	cp src/*.app ebin;
	erlc -I include -o ebin src/*.erl;
#	test application
	cp test_src/*.app test_ebin;
	erlc -D unit_test -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin\
	    -setcookie cookie_test\
	    -sname test\
	    -unit_test monitor_node test\
	    -unit_test cluster_id test\
	    -unit_test cookie cookie_test\
	    -run unit_test start_test test_src/test.config

Funeral

1. 2013-02-09
   1) trans mode : ssh->error
   2) edit mode : room_no
   3) show mode : s/\&/&nbsp;/g

2. 2013-02-13 (m "max 16 & delete sync V1.3")
   1) goin 2 line
   2) sangju MAX 16
   3) delete sync powersave (chrome.sh off)

3. openssh slave kill v1.4
   1) /lib/funeral.pm  trans & delete update

4. clean source v1.5
   1) funeral source clean

5. create branch v2.0
   1) the name of "branch", git checkout -b branch
6.     v2.1
7.     v2.2
8. 2013-03-04 update power save mode V2.3
   1) chrome.sh update
          ps_off  ->   ps_off.sh
          ps_on   ->   ps_on.sh
   2) /etc/lightdm/on.conf   -> ps_off.conf
      /etc/lightdm/off.conf  -> ps_on.conf
   3) source update (/lib/funeral.pm)
         delete    -> ps_on
         add       -> ps_off
   4) text slide   8 line -> 7 line

9. Lobby route add V3.0 (2013-03-15)
   1) funeral.pm add get lobby
   2) add to views  lobby.tt and css lobby.css

10. Source Optimizing V3.1 (2013-03-15)

11. Lobby function update V3.2 (2013-03-19)

12. Template Toolkit update V3.3 (2013-03-19)
    1) Tag change <%, %> => [%,%]
    2) config.yml

13. Lobyy 3 split V3.4 (2013-03-19)
    1) 1 screen 4 row
    2) lobby_1.tt 1-4 row, lobby_2.tt 1-8 row, lobby_3.tt 1-10 row

14. source clean up V3.5 (2013-03-20)
    1) table, sort, sname

15. source clean up V3.6 (2013-03-27)

16. Open V4.0 (2013-04-26)
    => open source
    
17. BugFix V4.1  (2013-04-29)
    1) lobby_2.tt lobby_3.tt colspan=\'2\'
    
18. change configure   V4.2  (2013-05-02)
    1) ssh_client 
    2) url_host
    3) ssh_passwd change  
    
19. DBMS change for PostgreSQL V4.3 (2013-05-03)
    1) change postgresql
    2) create gearman folder
    3) create sql folder
    4) move clear_picture.pl to /bin
    
20. Removal Screen Save V4.4 (2013-05-06)
	1) funeral.pm /add, /delete removal screen save
	
21. Initialize restart  V4.5 (2013-05-08)
    1) /delete restart lightdm
    
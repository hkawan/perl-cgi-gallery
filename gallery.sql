/* Database file relevant to the gallery.plx */

CREATE TABLE GALLERY
	(FILENAME VARCHAR(32),
	 DESCRIPTION VARCHAR(50),
         PRICE INT(4),
         STATUS VARCHAR(1));
INSERT into GALLERY VALUES
		('ReadingTheLetter.jpg', 'Reading the Letter', 5000, 'A');
		
INSERT into GALLERY VALUES('TheOldGuirarist.jpg', 'The Old Guitarist', 6500, 'A');

INSERT into GALLERY VALUES('Asleep.jpg', 'Asleep', 3000, 'A');		
INSERT into GALLERY VALUES('ThreeMusicians.jpg', 'Three Musicians', 4500, 'A');

commit;

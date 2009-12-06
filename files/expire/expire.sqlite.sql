CREATE TABLE expires (
  username varchar(100) not null,
  mailbox varchar(255) not null,
  expire_stamp integer not null,
  primary key (username, mailbox)
);
CREATE TRIGGER mergeexpires BEFORE INSERT ON expires FOR EACH ROW
BEGIN 
        UPDATE expires SET expire_stamp=NEW.expire_stamp 
                WHERE username = NEW.username AND mailbox = NEW.mailbox; 
        SELECT raise(ignore) 
                WHERE (SELECT 1 FROM expires WHERE username = NEW.username AND mailbox = NEW.mailbox) IS NOT NULL;
END;

<?php
/**
 * Private message class
 */
class Message {

	/**
	 * The registry object
	 */
	private $registry;
	
	/**
	 * ID of the message
	 */
	private $id=0;
	
	/**
	 * ID of the sender
	 */
	private $sender;
	
	/**
	 * Name of the sender
	 */
	private $senderName;
	
	/**
	 * ID of the recipient
	 */
	private $recipient;
	
	/**
	 * Name of the recipient
	 */
	private $recipientName;
	
	/**
	 * Subject of the message
	 */
	private $subject;
	
	/**
	 * When the message was sent (TIMESTAMP)
	 */
	private $sent;
	
	/**
	 * User readable, friendly format of the time the message was sent
	 */
	private $sentFriendlyTime;
	
	/**
	 * Has the message been read
	 */
	private $read=0;
	
	/**
	 * The message content itself
	 */
	private $message;
	
	/**
	 * Message constructor
	 * @param Registry $registry the registry object
	 * @param int $id the ID of the message
	 * @return void
	 */
	public function __construct( Registry $registry, $id=0 )
	{
		$this->registry = $registry;
		$this->id = $id;
		if( $this->id > 0 )
		{
			$sql = "SELECT m.*, DATE_FORMAT(m.sent, '%D %M %Y') as sent_friendly, psender.name as sender_name, precipient.name as recipient_name FROM messages m, profile psender, profile precipient WHERE precipient.user_id=m.recipient AND psender.user_id=m.sender AND m.ID=" . $this->id;
			$this->registry->getObject('db')->executeQuery( $sql );
			if( $this->registry->getObject('db')->numRows() > 0 )
			{
				$data = $this->registry->getObject('db')->getRows();
				$this->sender = $data['sender'];
				$this->recipient = $data['recipient'];
				$this->sent = $data['sent'];
				$this->read = $data['read'];
				$this->subject = $data['subject'];
				$this->message = $data['message'];
				$this->sentFriendlyTime = $data['sent_friendly'];
				$this->senderName = $data['sender_name'];
				$this->recipientName = $data['recipient_name'];
				
			}
			else
			{
				$this->id = 0;
			}
		}
	}
	
	/**
	 * Set the sender of the message
	 * @param int $sender
	 * @return void
	 */
	public function setSender( $sender )
	{
		$this->sender = $sender;	
	}
	
	/**
	 * Set the recipient of the message
	 * @param int $recipient 
	 * @return void
	 */
	public function setRecipient( $recipient )
	{
		$this->recipient = $recipient;
	}
	
	/**
	 * Set the subject of the message
	 * @param String $subject
	 * @return void
	 */
	public function setSubject( $subject )
	{
		$this->subject = $subject;
	}
	
	/**
	 * Set if the message has been read
	 * @param boolean $read
	 * @return void
	 */
	public function setRead( $read )
	{
		$this->read = $read;
	}
	
	/**
	 * Set the message itself
	 * @param String $message
	 * @return void
	 */
	public function setMessage( $message )
	{
		$this->message = $message;
	}
	
	/**
	 * Save the message into the database
	 * @return void
	 */
	public function save()
	{
		if( $this->id > 0 )
		{
			$update = array();
			$update['sender'] = $this->sender;
			$update['recipient'] = $this->recipient;
			$update['read'] = $this->read;
			$update['subject'] = $this->subject;
			$update['message'] = $this->message;
			$this->registry->getObject('db')->updateRecords( 'messages', $update, 'ID=' . $this->id );
		}
		else
		{
			$insert = array();
			$insert['sender'] = $this->sender;
			$insert['recipient'] = $this->recipient;
			$insert['read'] = $this->read;
			$insert['subject'] = $this->subject;
			$insert['message'] = $this->message;
			$this->registry->getObject('db')->insertRecords( 'messages', $insert );
			$this->id = $this->registry->getObject('db')->lastInsertID();
		}
	}
	
	/**
	 * Get the recipient of the message
	 * @return int
	 */
	public function getRecipient()
	{
		return $this->recipient;
	}
	
	/**
	 * Get the sender of the message
	 * @return int
	 */
	public function getSender()
	{
		return $this->sender;
	}
	
	/**
	 * Get the subject of the message
	 */
	public function getSubject()
	{
		return $this->subject;
	}
	
	/**
	 * Convert the message data to template tags
	 * @param String $prefix prefix for the template tags
	 * @return void
	 */
	public function toTags( $prefix='' )
	{
		foreach( $this as $field => $data )
		{
			if( ! is_object( $data ) && ! is_array( $data ) )
			{
				$this->registry->getObject('template')->getPage()->addTag( $prefix.$field, $data );
			}
		}
	}
	
	/**
	 * Delete the current message
	 * @return boolean
	 */
	public function delete()
	{
		$sql = "DELETE FROM messages WHERE ID=" . $this->id;
		$this->registry->getObject('db')->executeQuery( $sql );
		if( $this->registry->getObject('db')->affectedRows() > 0 )
		{
			$this->id =0;
			return true;
		}
		else
		{
			return false;
		}
	}
	
	
	
}


?>
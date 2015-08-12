<?php
/**
 * Messages controller
 * Basic private message system for Dino Space
 */
class Messagescontroller {
	
	/**
	 * Messages controller constructor
	 * @param Registry $registry
	 * @param boolean $directCall
	 * @return void
	 */
	public function __construct( Registry $registry, $directCall=true )
	{
		$this->registry = $registry;
		if( $this->registry->getObject('authenticate')->isLoggedIn() )
		{
			$urlBits = $this->registry->getObject('url')->getURLBits();
			if( isset( $urlBits[1] ) )
			{
				switch( $urlBits[1] )
				{
					case 'view':
						$this->viewMessage( intval( $urlBits[2] ) );
						break;
					case 'delete':
						$this->deleteMessage( intval( $urlBits[2] ) );
						break;
					case 'create':
						$this->newMessage( isset( $urlBits[2] ) ? intval( $urlBits[2] ) : 0 );
						break;	
					default:
						$this->viewInbox();
						break;
				}
				
			}
			else
			{
				$this->viewInbox();
			}
		}
		
	}
	
	/**
	 * View your inbox
	 * @return void
	 */
	private function viewInbox()
	{
		require_once( FRAMEWORK_PATH . 'models/messages.php' );
		$messages = new Messages( $this->registry );
		$cache = $messages->getInbox( $this->registry->getObject('authenticate')->getUser()->getUserID() );
		$this->registry->getObject('template')->buildFromTemplates('header.tpl.php', 'messages/inbox.tpl.php', 'footer.tpl.php');
		$this->registry->getObject('template')->getPage()->addTag( 'messages', array( 'SQL', $cache ) );
			
	}
	
	/**
	 * View a message
	 * @param int $message the ID of the message
	 * @return void
	 */
	private function viewMessage( $message )
	{
		require_once( FRAMEWORK_PATH . 'models/message.php' );
		$message = new Message( $this->registry, $message );
		if( $message->getRecipient() == $this->registry->getObject('authenticate')->getUser()->getUserID() )
		{
			$this->registry->getObject('template')->buildFromTemplates('header.tpl.php', 'messages/view.tpl.php', 'footer.tpl.php');
			$message->toTags( 'inbox_' );
			$message->setRead(1);
			$message->save();
		}
		else
		{
			$this->registry->errorPage( 'Access denied', 'Sorry, you are not allowed to view that message');
		}
	}
	
	/**
	 * Compose a new message, and process new message submissions
	 * @parm int $reply message ID this message is in reply to [optional] only used to pre-populate subject and recipient
	 * @return void
	 */
	private function newMessage( $reply=0 )
	{
		$this->registry->getObject('template')->buildFromTemplates('header.tpl.php', 'messages/create.tpl.php', 'footer.tpl.php');
			
		require_once( FRAMEWORK_PATH . 'models/relationships.php' );
		$relationships = new Relationships( $this->registry );
		
		if( isset( $_POST ) && count( $_POST ) > 0 )
		{
			$network = $relationships->getNetwork( $this->registry->getObject('authenticate')->getUser()->getUserID() );
			$recipient = intval( $_POST['recipient'] );
			if( in_array( $recipient, $network ) )
			{
				// this additional check may not be something we require for private messages?	
				require_once( FRAMEWORK_PATH . 'models/message.php' );
				$message = new Message( $this->registry, 0 );
				$message->setSender( $this->registry->getObject('authenticate')->getUser()->getUserID() );
				$message->setRecipient( $recipient );
				$message->setSubject( $this->registry->getObject('db')->sanitizeData( $_POST['subject'] ) );
				$message->setMessage( $this->registry->getObject('db')->sanitizeData( $_POST['message'] ) );
				$message->save();
				// email notification to the recipient perhaps??
				
				// confirm, and redirect
				$url = $this->registry->getObject('url')->buildURL( array('messages'), '', false );
			$this->registry->redirectUser( $url, 'Message sent', 'The message has been sent');
			}
			else
			{
				$this->registry->errorPage('Invalid recipient', 'Sorry, you can only send messages to your recipients');
			}
		}
		else
		{
			
			$cache = $relationships->getByUser( $this->registry->getObject('authenticate')->getUser()->getUserID() );
			$this->registry->getObject('template')->getPage()->addTag( 'recipients', array( 'SQL', $cache ) );
			if( $reply > 0 )
			{
				require_once( FRAMEWORK_PATH . 'models/message.php' );
				$message = new Message( $this->registry, $reply );
				if( $message->getRecipient() == $this->registry->getObject('authenticate')->getUser()->getUserID() )
				{
					$this->registry->getObject('template')->getPage()->addAdditionalParsingData( 'recipients', 'ID', $message->getSender(), 'opt', "selected='selected'");
					$this->registry->getObject('template')->getPage()->addTag( 'subject', 'Re: ' . $message->getSubject() );
				}
				else
				{
					$this->registry->getObject('template')->getPage()->addTag( 'subject', '' );
				}
				
			}
			else
			{
				$this->registry->getObject('template')->getPage()->addTag( 'subject', '' );
			}
		}
		
	}
	
	/**
	 * Delete a message
	 * @param int $message the message ID
	 * @return void
	 */
	private function deleteMessage( $message )
	{
		require_once( FRAMEWORK_PATH . 'models/message.php' );
		$message = new Message( $this->registry, $message );
		if( $message->getRecipient() == $this->registry->getObject('authenticate')->getUser()->getUserID() )
		{
			if( $message->delete() )
			{
				$url = $this->registry->getObject('url')->buildURL( array(), 'messages', false );
				$this->registry->redirectUser( $url, 'Message deleted', 'The message has been removed from your inbox');
			}
			else
			{
				$this->registry->errorPage( 'Sorry...', 'An error occured while trying to delete the message');
			}
		}
		else
		{
			$this->registry->errorPage( 'Access denied', 'Sorry, you are not allowed to delete that message');
		}
	}
	
	
	
}


?>
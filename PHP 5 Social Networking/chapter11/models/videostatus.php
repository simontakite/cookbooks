<?php

/**
 * Video status object
 * extends the base status object
 */
class Videostatus extends status {
	
	private $video_id;
	
	/**
	 * Constructor
	 * @param Registry $registry
	 * @param int $id
	 * @return void
	 */
	public function __construct( Registry $registry, $id = 0 )
	{
		$this->registry = $registry;
		parent::setTypeReference('video');
		parent::__construct( $this->registry, $id );
	}
	
	public function setVideoId( $vid )
	{
		$this->video_id = $vid;
	}
	
	public function setVideoIdFromURL( $url )
	{
		$data = array();
		parse_str( parse_url($url, PHP_URL_QUERY), $data );
		$this->video_id = $this->registry->getObject('db')->sanitizeData( isset( $data['v'] ) ? $data['v'] : '7NzzzcOWPH0' );
	}
	
	/**
	 * Save the video status
	 * @return void
	 */
	public function save()
	{
		// save the parent object and thus the status table
		parent::save();
		// grab the newly inserted status ID
		$id = $this->getID();
		// insert into the video status table, using the same ID
		$extended = array();
		$extended['id'] = $id;
		$extended['video_id'] = $this->video_id;
		$this->registry->getObject('db')->insertRecords( 'statuses_videos', $extended );
	}
	
}

?>
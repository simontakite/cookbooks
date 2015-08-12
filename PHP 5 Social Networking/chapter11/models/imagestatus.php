<?php

/**
 * Image status object
 * extends the base status object
 */
class Imagestatus extends status {
	
	private $image;
	
	/**
	 * Constructor
	 * @param Registry $registry
	 * @param int $id
	 * @return void
	 */
	public function __construct( Registry $registry, $id = 0 )
	{
		$this->registry = $registry;
		parent::setTypeReference('image');
		parent::__construct( $this->registry, $id );
	}
	
	/**
	 * Process an image upload and set the image
	 * @param String $postfield the $_POST field the image was uploaded through
	 * @return boolean
	 */
	public function processImage( $postfield )
	{
		require_once( FRAMEWORK_PATH . 'lib/images/imagemanager.class.php' );
		$im = new Imagemanager();
		$prefix = time() . '_';
		if( $im->loadFromPost( $postfield, $this->registry->getSetting('upload_path') . 'statusimages/', $prefix ) )
		{
			$im->resizeScaleWidth( 150 );
			$im->save( $this->registry->getSetting('upload_path') . 'statusimages/' . $im->getName() );
			$this->image = $im->getName();
			return true;
		}
		else
		{
			return false;
		}
		
	}
	
	/**
	 * Save the image status
	 * @return void
	 */
	public function save()
	{
		// save the parent object and thus the status table
		parent::save();
		// grab the newly inserted status ID
		$id = $this->getID();
		// insert into the images status table, using the same ID
		$extended = array();
		$extended['id'] = $id;
		$extended['image'] = $this->image;
		$this->registry->getObject('db')->insertRecords( 'statuses_images', $extended );
	}
	
}

?>
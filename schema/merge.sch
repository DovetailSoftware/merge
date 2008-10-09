/*************************************************************************
 *
 * Product        :  fcMerge                                    
 *                                                                          
 * Name           :  merge.sch
 *                                                                           
 * Description    :  This partial schema file provides information required
 *                   required to update a Clarify schema for the Contact/Site
 *                   merge product.
 *
 *
 *                   Use a text editor to cut+paste these changes into
 *                   a current Clarify schema file.
 *
 * Usage          :  * Use the Clarify Data Dictionary Editor to export a schema file
 *                   * Use a text editor to cut+paste these changes into the file
 *                   * Use the Data Dictionary Editor to apply the schema file
 *
 * Author         :  First Choice Software, Inc.                             
 *                   8900 Business Park Drive
 *                   Austin, TX  78759                                       
 *                   (512) 418-2905                                          
 *                                                                           
 * Platforms      :  This version supports Clarify 4.5 and later             
 *                                                                           
 * Copyright (C)  2005 First Choice Software, Inc.                           
 * All Rights Reserved                                                       
 *************************************************************************/

/*
 * Add the following as the last fields in OBJECT contact
 */
,
    x_objid_master  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="Objid of master contact for this contact. Indicates that this contact is an alias for the master contact."
,
    x_no_alias  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="If set to 1, this contact cannot become an alias. If set to 0 (default), it can."
,
    x_marked_by  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="Which user (objid) marked this alias?"

/*
 * Add the following relations as the last relations in OBJECT contact
 *
 * Any relation that is declared as USER_DEFINED must be located after any other 
 * relations that are defined by Clarify. Both the relation and the inverse relation
 * must have the USER_DEFINED notation, or an error will be reported during the update.
 */
,
    contact2alias OTM contact USER_DEFINED
     INV_REL=alias2contact COMMENT="Aliases for this contact"
,
    alias2contact MTO contact USER_DEFINED
     INV_REL=contact2alias COMMENT="Contact for this alias"

/*
 * Add the following as the last fields in OBJECT site
 */
,
    x_objid_master  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     MANDATORY USER_DEFINED
     COMMENT="What is the master objid for this alias?"
,
    x_no_alias  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="If set to 1, this site cannot become an alias. If set to 0 (default), it can."
,
    x_marked_by  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="Which user (objid) marked this alias?"

/*
 * Add the following relations as the last relations in OBJECT site
 *
 * Any relation that is declared as USER_DEFINED must be located after any other 
 * relations that are defined by Clarify. Both the relation and the inverse relation
 * must have the USER_DEFINED notation, or an error will be reported during the update.
 */

,
    site2alias OTM site USER_DEFINED
     INV_REL=alias2site COMMENT="Aliases for this site"
,
    alias2site MTO site USER_DEFINED
     INV_REL=site2alias COMMENT="Parent site for this alias"

/*
 * Add the following field as the last field in the VIEW rol_contct
 */
 
,
    x_no_alias	FROM	contact.x_no_alias
     COMMENT="Is this contact a no alias one?"

/*
 * Add the following field as the last field in the VIEW site_view
 */

,
   x_no_alias	FROM	site.x_no_alias
     COMMENT="Is this site a no alias one?"

/*
 * For Clarify version 7.x and earlier, 
 * Add the following field as the last field in the VIEW site_view
 */

,
   address_2	FROM	address.address_2
     COMMENT="Address Line 2"


/*
 * Add the following as the last fields in OBJECT address
 */
,
    x_objid_master  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="Objid of master address for this address. Indicates that this address is an alias for the master address."
,
    x_no_alias  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="If set to 1, this address cannot become an alias. If set to 0 (default), it can."
,
    x_marked_by  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="Which user (objid) marked this alias?"

/*
 * Add the following relations as the last relations in OBJECT address
 *
 * Any relation that is declared as USER_DEFINED must be located after any other 
 * relations that are defined by Clarify. Both the relation and the inverse relation
 * must have the USER_DEFINED notation, or an error will be reported during the update.
 */

,
    address2alias OTM address USER_DEFINED
     INV_REL=alias2address COMMENT="Aliases for this address"
,
    alias2address MTO address USER_DEFINED
     INV_REL=address2alias COMMENT="Address for this alias"

/*
 * Add the following as the last fields in OBJECT part_num
 */

,
    x_objid_master  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="Objid of master address for this part. Indicates that this part is an alias for the master part."
,
    x_no_alias  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="If set to 1, this part cannot become an alias. If set to 0 (default), it can."
,
    x_marked_by  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="Which user (objid) marked this alias?"

/*
 * Add the following relations as the last relations in OBJECT part
 *
 * Any relation that is declared as USER_DEFINED must be located after any other 
 * relations that are defined by Clarify. Both the relation and the inverse relation
 * must have the USER_DEFINED notation, or an error will be reported during the update.
 */

,
    part_num2alias OTM part_num USER_DEFINED
     INV_REL=alias2part_num COMMENT="Aliases for this part"
,
    alias2part_num MTO part_num USER_DEFINED
     INV_REL=part_num2alias COMMENT="Part_num (master) for this part"

/*
 * Add the following view at the end of the file
 */

VIEW merge_address_view 4270
 SUBJECT="Merge"
 COMMENT="Joins address, country, state, and time_zone"
  FIELDS
   objid        FROM    address.objid GEN_FIELD_ID=3
     COMMENT="address objid",
   address	FROM	address.address
     COMMENT="address",
   address_2	FROM	address.address_2
     COMMENT="address line 2",
   city	FROM	address.city
     COMMENT="city",
   state	FROM	address.state
     COMMENT="state",
   zipcode	FROM	address.zipcode
     COMMENT="zipcode",
   country	FROM	country.name
     COMMENT="country",
   time_zone	FROM	time_zone.name
     COMMENT="time zone",
   x_no_alias	FROM	address.x_no_alias
     COMMENT="This address cannot be marked as an alias"
  FIELDS_END
  JOINS
    address.address2country = country.country2address
     COMMENT="",
    address.address2time_zone = time_zone.time_zone2address
     COMMENT=""
  JOINS_END
VIEW_END;


/*
 * Add the following as the last fields in OBJECT employee
 */
,
    x_objid_master  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="Objid of master employee for this employee. Indicates that this employee is an alias for the master employee."
,
    x_no_alias  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="If set to 1, this employee cannot become an alias. If set to 0 (default), it can."
,
    x_marked_by  CMN_DATA_TYPE="long integer" DB_DATA_TYPE=0
     OPTIONAL USER_DEFINED
     COMMENT="Which user (objid) marked this alias?"

/*
 * Add the following relations as the last relations in OBJECT employee
 *
 * Any relation that is declared as USER_DEFINED must be located after any other 
 * relations that are defined by Clarify. Both the relation and the inverse relation
 * must have the USER_DEFINED notation, or an error will be reported during the update.
 */

,
    employee2alias OTM employee USER_DEFINED
     INV_REL=alias2employee COMMENT="Aliases for this employee"
,
    alias2employee MTO employee USER_DEFINED
     INV_REL=employee2alias COMMENT="employee for this alias"

/*
 * Add the following fields to the empl_user view
 */

,
   x_objid_master	FROM	employee.x_objid_master
     COMMENT="Objid of master employee for this employee. Indicates that this employee is an alias for the master employee."
,
   x_no_alias	FROM	employee.x_no_alias
     COMMENT="If set to 1, this employee cannot become an alias. If set to 0 (default), it can."
,
   x_marked_by	FROM	employee.x_marked_by
     COMMENT="Which user (objid) marked this alias?"


/*
 * That's it.
 */


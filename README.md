# Merge

During the operation of a Customer Service System, a common problem encountered is the accumulation of “alias” or
“duplicate” contacts, sites, addresses, employees, and parts in the system. 

fcMerge provides an effective way of identifying, marking and eliminating duplicate objects from your customer service process.

An “alias” or “duplicate” contact is the presence of multiple data records in the database representing one individual
contact, typically as the result of a minor differences in the spelling of the contact’s name. An example could be the
presence of three contact records “Mary Smith”, “Mary J. Smith” and “Mary Joan Smith” in the database, all representing
the same individual customer “Mary Smith”.

Similarly, a duplicate site is the presence of multiple site records in the database representing one specific site. For
example, “Clarify - Austin” and “Clarify/Austin” might accidentally both be entered into your system.

The same is true for other duplicate objects, such as addresses, employees, and parts (products).

A customer service agent may inadvertently add these aliases to the database if they cannot find a contact or site for some
reason in the database, or by interfaces performing batch loads of customer/site data from other systems. The problem
with these aliases is that they can skew metrics, as well as result in customer service errors when contact/site attributes
(such as fax number) are changed for one alias, but not the others. As a result, it is desirable to identify and potentially
eliminate these aliases from your customer service processes.

## Documentation

Documentation is located in the docs directory

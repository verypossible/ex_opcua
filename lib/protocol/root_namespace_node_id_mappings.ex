defmodule ExOpcua.Protocol.RootNamespaceNodeIDMappings do
    @moduledoc """
        This Module Contains Constant numeric Identifiers for Namespace 0 variable definitions
        These default types should be prepended with NamespaceIndex 0
    """
    # DataType
    defmacro ua_ns0id_BOOLEAN, do: quote(do: 1)
    # DataType
    defmacro ua_ns0id_SBYTE, do: quote(do: 2)
    # DataType
    defmacro ua_ns0id_BYTE, do: quote(do: 3)
    # DataType
    defmacro ua_ns0id_INT16, do: quote(do: 4)
    # DataType
    defmacro ua_ns0id_UINT16, do: quote(do: 5)
    # DataType
    defmacro ua_ns0id_INT32, do: quote(do: 6)
    # DataType
    defmacro ua_ns0id_UINT32, do: quote(do: 7)
    # DataType
    defmacro ua_ns0id_INT64, do: quote(do: 8)
    # DataType
    defmacro ua_ns0id_UINT64, do: quote(do: 9)
    # DataType
    defmacro ua_ns0id_FLOAT, do: quote(do: 10)
    # DataType
    defmacro ua_ns0id_DOUBLE, do: quote(do: 11)
    # DataType
    defmacro ua_ns0id_STRING, do: quote(do: 12)
    # DataType
    defmacro ua_ns0id_DATETIME, do: quote(do: 13)
    # DataType
    defmacro ua_ns0id_GUID, do: quote(do: 14)
    # DataType
    defmacro ua_ns0id_BYTESTRING, do: quote(do: 15)
    # DataType
    defmacro ua_ns0id_XMLELEMENT, do: quote(do: 16)
    # DataType
    defmacro ua_ns0id_NODEID, do: quote(do: 17)
    # DataType
    defmacro ua_ns0id_EXPANDEDNODEID, do: quote(do: 18)
    # DataType
    defmacro ua_ns0id_STATUSCODE, do: quote(do: 19)
    # DataType
    defmacro ua_ns0id_QUALIFIEDNAME, do: quote(do: 20)
    # DataType
    defmacro ua_ns0id_LOCALIZEDTEXT, do: quote(do: 21)
    # DataType
    defmacro ua_ns0id_STRUCTURE, do: quote(do: 22)
    # DataType
    defmacro ua_ns0id_DATAVALUE, do: quote(do: 23)
    # DataType
    defmacro ua_ns0id_BASEDATATYPE, do: quote(do: 24)
    # DataType
    defmacro ua_ns0id_DIAGNOSTICINFO, do: quote(do: 25)
    # DataType
    defmacro ua_ns0id_NUMBER, do: quote(do: 26)
    # DataType
    defmacro ua_ns0id_INTEGER, do: quote(do: 27)
    # DataType
    defmacro ua_ns0id_UINTEGER, do: quote(do: 28)
    # DataType
    defmacro ua_ns0id_ENUMERATION, do: quote(do: 29)
    # DataType
    defmacro ua_ns0id_IMAGE, do: quote(do: 30)
    # ReferenceType
    defmacro ua_ns0id_REFERENCES, do: quote(do: 31)
    # ReferenceType
    defmacro ua_ns0id_NONHIERARCHICALREFERENCES, do: quote(do: 32)
    # ReferenceType
    defmacro ua_ns0id_HIERARCHICALREFERENCES, do: quote(do: 33)
    # ReferenceType
    defmacro ua_ns0id_HASCHILD, do: quote(do: 34)
    # ReferenceType
    defmacro ua_ns0id_ORGANIZES, do: quote(do: 35)
    # ReferenceType
    defmacro ua_ns0id_HASEVENTSOURCE, do: quote(do: 36)
    # ReferenceType
    defmacro ua_ns0id_HASMODELLINGRULE, do: quote(do: 37)
    # ReferenceType
    defmacro ua_ns0id_HASENCODING, do: quote(do: 38)
    # ReferenceType
    defmacro ua_ns0id_HASDESCRIPTION, do: quote(do: 39)
    # ReferenceType
    defmacro ua_ns0id_HASTYPEDEFINITION, do: quote(do: 40)
    # ReferenceType
    defmacro ua_ns0id_GENERATESEVENT, do: quote(do: 41)
    # ReferenceType
    defmacro ua_ns0id_AGGREGATES, do: quote(do: 44)
    # ReferenceType
    defmacro ua_ns0id_HASSUBTYPE, do: quote(do: 45)
    # ReferenceType
    defmacro ua_ns0id_HASPROPERTY, do: quote(do: 46)
    # ReferenceType
    defmacro ua_ns0id_HASCOMPONENT, do: quote(do: 47)
    # ReferenceType
    defmacro ua_ns0id_HASNOTIFIER, do: quote(do: 48)
    # ReferenceType
    defmacro ua_ns0id_HASORDEREDCOMPONENT, do: quote(do: 49)
    # ReferenceType
    defmacro ua_ns0id_HASMODELPARENT, do: quote(do: 50)
    # ReferenceType
    defmacro ua_ns0id_FROMSTATE, do: quote(do: 51)
    # ReferenceType
    defmacro ua_ns0id_TOSTATE, do: quote(do: 52)
    # ReferenceType
    defmacro ua_ns0id_HASCAUSE, do: quote(do: 53)
    # ReferenceType
    defmacro ua_ns0id_HASEFFECT, do: quote(do: 54)
    # ReferenceType
    defmacro ua_ns0id_HASHISTORICALCONFIGURATION, do: quote(do: 56)
    # ObjectType
    defmacro ua_ns0id_BASEOBJECTTYPE, do: quote(do: 58)
    # ObjectType
    defmacro ua_ns0id_FOLDERTYPE, do: quote(do: 61)
    # VariableType
    defmacro ua_ns0id_BASEVARIABLETYPE, do: quote(do: 62)
    # VariableType
    defmacro ua_ns0id_BASEDATAVARIABLETYPE, do: quote(do: 63)
    # VariableType
    defmacro ua_ns0id_PROPERTYTYPE, do: quote(do: 68)
    # VariableType
    defmacro ua_ns0id_DATATYPEDESCRIPTIONTYPE, do: quote(do: 69)
    # VariableType
    defmacro ua_ns0id_DATATYPEDICTIONARYTYPE, do: quote(do: 72)
    # ObjectType
    defmacro ua_ns0id_DATATYPESYSTEMTYPE, do: quote(do: 75)
    # ObjectType
    defmacro ua_ns0id_DATATYPEENCODINGTYPE, do: quote(do: 76)
    # ObjectType
    defmacro ua_ns0id_MODELLINGRULETYPE, do: quote(do: 77)
    # Object
    defmacro ua_ns0id_MODELLINGRULE_MANDATORY, do: quote(do: 78)
    # Object
    defmacro ua_ns0id_MODELLINGRULE_MANDATORYSHARED, do: quote(do: 79)
    # Object
    defmacro ua_ns0id_MODELLINGRULE_OPTIONAL, do: quote(do: 80)
    # Object
    defmacro ua_ns0id_MODELLINGRULE_EXPOSESITSARRAY, do: quote(do: 83)
    # Object
    defmacro ua_ns0id_ROOTFOLDER, do: quote(do: 84)
    # Object
    defmacro ua_ns0id_OBJECTSFOLDER, do: quote(do: 85)
    # Object
    defmacro ua_ns0id_TYPESFOLDER, do: quote(do: 86)
    # Object
    defmacro ua_ns0id_VIEWSFOLDER, do: quote(do: 87)
    # Object
    defmacro ua_ns0id_OBJECTTYPESFOLDER, do: quote(do: 88)
    # Object
    defmacro ua_ns0id_VARIABLETYPESFOLDER, do: quote(do: 89)
    # Object
    defmacro ua_ns0id_DATATYPESFOLDER, do: quote(do: 90)
    # Object
    defmacro ua_ns0id_REFERENCETYPESFOLDER, do: quote(do: 91)
    # Object
    defmacro ua_ns0id_XMLSCHEMA_TYPESYSTEM, do: quote(do: 92)
    # Object
    defmacro ua_ns0id_OPCBINARYSCHEMA_TYPESYSTEM, do: quote(do: 93)
    # Variable
    defmacro ua_ns0id_MODELLINGRULE_MANDATORY_NAMINGRULE, do: quote(do: 112)
    # Variable
    defmacro ua_ns0id_MODELLINGRULE_OPTIONAL_NAMINGRULE, do: quote(do: 113)
    # Variable
    defmacro ua_ns0id_MODELLINGRULE_EXPOSESITSARRAY_NAMINGRULE, do: quote(do: 114)
    # Variable
    defmacro ua_ns0id_MODELLINGRULE_MANDATORYSHARED_NAMINGRULE, do: quote(do: 116)
    # ReferenceType
    defmacro ua_ns0id_HASSUBSTATEMACHINE, do: quote(do: 117)
    # DataType
    defmacro ua_ns0id_NAMINGRULETYPE, do: quote(do: 120)
    # DataType
    defmacro ua_ns0id_IDTYPE, do: quote(do: 256)
    # DataType
    defmacro ua_ns0id_NODECLASS, do: quote(do: 257)
    # DataType
    defmacro ua_ns0id_NODE, do: quote(do: 258)
    # DataType
    defmacro ua_ns0id_OBJECTNODE, do: quote(do: 261)
    # DataType
    defmacro ua_ns0id_OBJECTTYPENODE, do: quote(do: 264)
    # DataType
    defmacro ua_ns0id_VARIABLENODE, do: quote(do: 267)
    # DataType
    defmacro ua_ns0id_VARIABLETYPENODE, do: quote(do: 270)
    # DataType
    defmacro ua_ns0id_REFERENCETYPENODE, do: quote(do: 273)
    # DataType
    defmacro ua_ns0id_METHODNODE, do: quote(do: 276)
    # DataType
    defmacro ua_ns0id_VIEWNODE, do: quote(do: 279)
    # DataType
    defmacro ua_ns0id_DATATYPENODE, do: quote(do: 282)
    # DataType
    defmacro ua_ns0id_REFERENCENODE, do: quote(do: 285)
    # DataType
    defmacro ua_ns0id_INTEGERID, do: quote(do: 288)
    # DataType
    defmacro ua_ns0id_COUNTER, do: quote(do: 289)
    # DataType
    defmacro ua_ns0id_DURATION, do: quote(do: 290)
    # DataType
    defmacro ua_ns0id_NUMERICRANGE, do: quote(do: 291)
    # DataType
    defmacro ua_ns0id_TIME, do: quote(do: 292)
    # DataType
    defmacro ua_ns0id_DATE, do: quote(do: 293)
    # DataType
    defmacro ua_ns0id_UTCTIME, do: quote(do: 294)
    # DataType
    defmacro ua_ns0id_LOCALEID, do: quote(do: 295)
    # DataType
    defmacro ua_ns0id_ARGUMENT, do: quote(do: 296)
    # DataType
    defmacro ua_ns0id_STATUSRESULT, do: quote(do: 299)
    # DataType
    defmacro ua_ns0id_MESSAGESECURITYMODE, do: quote(do: 302)
    # DataType
    defmacro ua_ns0id_USERTOKENTYPE, do: quote(do: 303)
    # DataType
    defmacro ua_ns0id_USERTOKENPOLICY, do: quote(do: 304)
    # DataType
    defmacro ua_ns0id_APPLICATIONTYPE, do: quote(do: 307)
    # DataType
    defmacro ua_ns0id_APPLICATIONDESCRIPTION, do: quote(do: 308)
    # DataType
    defmacro ua_ns0id_APPLICATIONINSTANCECERTIFICATE, do: quote(do: 311)
    # DataType
    defmacro ua_ns0id_ENDPOINTDESCRIPTION, do: quote(do: 312)
    # DataType
    defmacro ua_ns0id_SECURITYTOKENREQUESTTYPE, do: quote(do: 315)
    # DataType
    defmacro ua_ns0id_USERIDENTITYTOKEN, do: quote(do: 316)
    # DataType
    defmacro ua_ns0id_ANONYMOUSIDENTITYTOKEN, do: quote(do: 319)
    # DataType
    defmacro ua_ns0id_USERNAMEIDENTITYTOKEN, do: quote(do: 322)
    # DataType
    defmacro ua_ns0id_X509IDENTITYTOKEN, do: quote(do: 325)
    # DataType
    defmacro ua_ns0id_ENDPOINTCONFIGURATION, do: quote(do: 331)
    # DataType
    defmacro ua_ns0id_COMPLIANCELEVEL, do: quote(do: 334)
    # DataType
    defmacro ua_ns0id_SUPPORTEDPROFILE, do: quote(do: 335)
    # DataType
    defmacro ua_ns0id_BUILDINFO, do: quote(do: 338)
    # DataType
    defmacro ua_ns0id_SOFTWARECERTIFICATE, do: quote(do: 341)
    # DataType
    defmacro ua_ns0id_SIGNEDSOFTWARECERTIFICATE, do: quote(do: 344)
    # DataType
    defmacro ua_ns0id_ATTRIBUTEWRITEMASK, do: quote(do: 347)
    # DataType
    defmacro ua_ns0id_NODEATTRIBUTESMASK, do: quote(do: 348)
    # DataType
    defmacro ua_ns0id_NODEATTRIBUTES, do: quote(do: 349)
    # DataType
    defmacro ua_ns0id_OBJECTATTRIBUTES, do: quote(do: 352)
    # DataType
    defmacro ua_ns0id_VARIABLEATTRIBUTES, do: quote(do: 355)
    # DataType
    defmacro ua_ns0id_METHODATTRIBUTES, do: quote(do: 358)
    # DataType
    defmacro ua_ns0id_OBJECTTYPEATTRIBUTES, do: quote(do: 361)
    # DataType
    defmacro ua_ns0id_VARIABLETYPEATTRIBUTES, do: quote(do: 364)
    # DataType
    defmacro ua_ns0id_REFERENCETYPEATTRIBUTES, do: quote(do: 367)
    # DataType
    defmacro ua_ns0id_DATATYPEATTRIBUTES, do: quote(do: 370)
    # DataType
    defmacro ua_ns0id_VIEWATTRIBUTES, do: quote(do: 373)
    # DataType
    defmacro ua_ns0id_ADDNODESITEM, do: quote(do: 376)
    # DataType
    defmacro ua_ns0id_ADDREFERENCESITEM, do: quote(do: 379)
    # DataType
    defmacro ua_ns0id_DELETENODESITEM, do: quote(do: 382)
    # DataType
    defmacro ua_ns0id_DELETEREFERENCESITEM, do: quote(do: 385)
    # DataType
    defmacro ua_ns0id_SESSIONAUTHENTICATIONTOKEN, do: quote(do: 388)
    # DataType
    defmacro ua_ns0id_REQUESTHEADER, do: quote(do: 389)
    # DataType
    defmacro ua_ns0id_RESPONSEHEADER, do: quote(do: 392)
    # DataType
    defmacro ua_ns0id_SERVICEFAULT, do: quote(do: 395)
    # DataType
    defmacro ua_ns0id_FINDSERVERSREQUEST, do: quote(do: 420)
    # DataType
    defmacro ua_ns0id_FINDSERVERSRESPONSE, do: quote(do: 423)
    # DataType
    defmacro ua_ns0id_GETENDPOINTSREQUEST, do: quote(do: 426)
    # DataType
    defmacro ua_ns0id_GETENDPOINTSRESPONSE, do: quote(do: 429)
    # DataType
    defmacro ua_ns0id_REGISTEREDSERVER, do: quote(do: 432)
    # DataType
    defmacro ua_ns0id_REGISTERSERVERREQUEST, do: quote(do: 435)
    # DataType
    defmacro ua_ns0id_REGISTERSERVERRESPONSE, do: quote(do: 438)
    # DataType
    defmacro ua_ns0id_CHANNELSECURITYTOKEN, do: quote(do: 441)
    # DataType
    defmacro ua_ns0id_OPENSECURECHANNELREQUEST, do: quote(do: 444)
    # DataType
    defmacro ua_ns0id_OPENSECURECHANNELRESPONSE, do: quote(do: 447)
    # DataType
    defmacro ua_ns0id_CLOSESECURECHANNELREQUEST, do: quote(do: 450)
    # DataType
    defmacro ua_ns0id_CLOSESECURECHANNELRESPONSE, do: quote(do: 453)
    # DataType
    defmacro ua_ns0id_SIGNATUREDATA, do: quote(do: 456)
    # DataType
    defmacro ua_ns0id_CREATESESSIONREQUEST, do: quote(do: 459)
    # DataType
    defmacro ua_ns0id_CREATESESSIONRESPONSE, do: quote(do: 462)
    # DataType
    defmacro ua_ns0id_ACTIVATESESSIONREQUEST, do: quote(do: 465)
    # DataType
    defmacro ua_ns0id_ACTIVATESESSIONRESPONSE, do: quote(do: 468)
    # DataType
    defmacro ua_ns0id_CLOSESESSIONREQUEST, do: quote(do: 471)
    # DataType
    defmacro ua_ns0id_CLOSESESSIONRESPONSE, do: quote(do: 474)
    # DataType
    defmacro ua_ns0id_CANCELREQUEST, do: quote(do: 477)
    # DataType
    defmacro ua_ns0id_CANCELRESPONSE, do: quote(do: 480)
    # DataType
    defmacro ua_ns0id_ADDNODESRESULT, do: quote(do: 483)
    # DataType
    defmacro ua_ns0id_ADDNODESREQUEST, do: quote(do: 486)
    # DataType
    defmacro ua_ns0id_ADDNODESRESPONSE, do: quote(do: 489)
    # DataType
    defmacro ua_ns0id_ADDREFERENCESREQUEST, do: quote(do: 492)
    # DataType
    defmacro ua_ns0id_ADDREFERENCESRESPONSE, do: quote(do: 495)
    # DataType
    defmacro ua_ns0id_DELETENODESREQUEST, do: quote(do: 498)
    # DataType
    defmacro ua_ns0id_DELETENODESRESPONSE, do: quote(do: 501)
    # DataType
    defmacro ua_ns0id_DELETEREFERENCESREQUEST, do: quote(do: 504)
    # DataType
    defmacro ua_ns0id_DELETEREFERENCESRESPONSE, do: quote(do: 507)
    # DataType
    defmacro ua_ns0id_BROWSEDIRECTION, do: quote(do: 510)
    # DataType
    defmacro ua_ns0id_VIEWDESCRIPTION, do: quote(do: 511)
    # DataType
    defmacro ua_ns0id_BROWSEDESCRIPTION, do: quote(do: 514)
    # DataType
    defmacro ua_ns0id_BROWSERESULTMASK, do: quote(do: 517)
    # DataType
    defmacro ua_ns0id_REFERENCEDESCRIPTION, do: quote(do: 518)
    # DataType
    defmacro ua_ns0id_CONTINUATIONPOINT, do: quote(do: 521)
    # DataType
    defmacro ua_ns0id_BROWSERESULT, do: quote(do: 522)
    # DataType
    defmacro ua_ns0id_BROWSEREQUEST, do: quote(do: 525)
    # DataType
    defmacro ua_ns0id_BROWSERESPONSE, do: quote(do: 528)
    # DataType
    defmacro ua_ns0id_BROWSENEXTREQUEST, do: quote(do: 531)
    # DataType
    defmacro ua_ns0id_BROWSENEXTRESPONSE, do: quote(do: 534)
    # DataType
    defmacro ua_ns0id_RELATIVEPATHELEMENT, do: quote(do: 537)
    # DataType
    defmacro ua_ns0id_RELATIVEPATH, do: quote(do: 540)
    # DataType
    defmacro ua_ns0id_BROWSEPATH, do: quote(do: 543)
    # DataType
    defmacro ua_ns0id_BROWSEPATHTARGET, do: quote(do: 546)
    # DataType
    defmacro ua_ns0id_BROWSEPATHRESULT, do: quote(do: 549)
    # DataType
    defmacro ua_ns0id_TRANSLATEBROWSEPATHSTONODEIDSREQUEST, do: quote(do: 552)
    # DataType
    defmacro ua_ns0id_TRANSLATEBROWSEPATHSTONODEIDSRESPONSE, do: quote(do: 555)
    # DataType
    defmacro ua_ns0id_REGISTERNODESREQUEST, do: quote(do: 558)
    # DataType
    defmacro ua_ns0id_REGISTERNODESRESPONSE, do: quote(do: 561)
    # DataType
    defmacro ua_ns0id_UNREGISTERNODESREQUEST, do: quote(do: 564)
    # DataType
    defmacro ua_ns0id_UNREGISTERNODESRESPONSE, do: quote(do: 567)
    # DataType
    defmacro ua_ns0id_QUERYDATADESCRIPTION, do: quote(do: 570)
    # DataType
    defmacro ua_ns0id_NODETYPEDESCRIPTION, do: quote(do: 573)
    # DataType
    defmacro ua_ns0id_FILTEROPERATOR, do: quote(do: 576)
    # DataType
    defmacro ua_ns0id_QUERYDATASET, do: quote(do: 577)
    # DataType
    defmacro ua_ns0id_NODEREFERENCE, do: quote(do: 580)
    # DataType
    defmacro ua_ns0id_CONTENTFILTERELEMENT, do: quote(do: 583)
    # DataType
    defmacro ua_ns0id_CONTENTFILTER, do: quote(do: 586)
    # DataType
    defmacro ua_ns0id_FILTEROPERAND, do: quote(do: 589)
    # DataType
    defmacro ua_ns0id_ELEMENTOPERAND, do: quote(do: 592)
    # DataType
    defmacro ua_ns0id_LITERALOPERAND, do: quote(do: 595)
    # DataType
    defmacro ua_ns0id_ATTRIBUTEOPERAND, do: quote(do: 598)
    # DataType
    defmacro ua_ns0id_SIMPLEATTRIBUTEOPERAND, do: quote(do: 601)
    # DataType
    defmacro ua_ns0id_CONTENTFILTERELEMENTRESULT, do: quote(do: 604)
    # DataType
    defmacro ua_ns0id_CONTENTFILTERRESULT, do: quote(do: 607)
    # DataType
    defmacro ua_ns0id_PARSINGRESULT, do: quote(do: 610)
    # DataType
    defmacro ua_ns0id_QUERYFIRSTREQUEST, do: quote(do: 613)
    # DataType
    defmacro ua_ns0id_QUERYFIRSTRESPONSE, do: quote(do: 616)
    # DataType
    defmacro ua_ns0id_QUERYNEXTREQUEST, do: quote(do: 619)
    # DataType
    defmacro ua_ns0id_QUERYNEXTRESPONSE, do: quote(do: 622)
    # DataType
    defmacro ua_ns0id_TIMESTAMPSTORETURN, do: quote(do: 625)
    # DataType
    defmacro ua_ns0id_READVALUEID, do: quote(do: 626)
    # DataType
    defmacro ua_ns0id_READREQUEST, do: quote(do: 629)
    # DataType
    defmacro ua_ns0id_READRESPONSE, do: quote(do: 632)
    # DataType
    defmacro ua_ns0id_HISTORYREADVALUEID, do: quote(do: 635)
    # DataType
    defmacro ua_ns0id_HISTORYREADRESULT, do: quote(do: 638)
    # DataType
    defmacro ua_ns0id_HISTORYREADDETAILS, do: quote(do: 641)
    # DataType
    defmacro ua_ns0id_READEVENTDETAILS, do: quote(do: 644)
    # DataType
    defmacro ua_ns0id_READRAWMODIFIEDDETAILS, do: quote(do: 647)
    # DataType
    defmacro ua_ns0id_READPROCESSEDDETAILS, do: quote(do: 650)
    # DataType
    defmacro ua_ns0id_READATTIMEDETAILS, do: quote(do: 653)
    # DataType
    defmacro ua_ns0id_HISTORYDATA, do: quote(do: 656)
    # DataType
    defmacro ua_ns0id_HISTORYEVENT, do: quote(do: 659)
    # DataType
    defmacro ua_ns0id_HISTORYREADREQUEST, do: quote(do: 662)
    # DataType
    defmacro ua_ns0id_HISTORYREADRESPONSE, do: quote(do: 665)
    # DataType
    defmacro ua_ns0id_WRITEVALUE, do: quote(do: 668)
    # DataType
    defmacro ua_ns0id_WRITEREQUEST, do: quote(do: 671)
    # DataType
    defmacro ua_ns0id_WRITERESPONSE, do: quote(do: 674)
    # DataType
    defmacro ua_ns0id_HISTORYUPDATEDETAILS, do: quote(do: 677)
    # DataType
    defmacro ua_ns0id_UPDATEDATADETAILS, do: quote(do: 680)
    # DataType
    defmacro ua_ns0id_UPDATEEVENTDETAILS, do: quote(do: 683)
    # DataType
    defmacro ua_ns0id_DELETERAWMODIFIEDDETAILS, do: quote(do: 686)
    # DataType
    defmacro ua_ns0id_DELETEATTIMEDETAILS, do: quote(do: 689)
    # DataType
    defmacro ua_ns0id_DELETEEVENTDETAILS, do: quote(do: 692)
    # DataType
    defmacro ua_ns0id_HISTORYUPDATERESULT, do: quote(do: 695)
    # DataType
    defmacro ua_ns0id_HISTORYUPDATEREQUEST, do: quote(do: 698)
    # DataType
    defmacro ua_ns0id_HISTORYUPDATERESPONSE, do: quote(do: 701)
    # DataType
    defmacro ua_ns0id_CALLMETHODREQUEST, do: quote(do: 704)
    # DataType
    defmacro ua_ns0id_CALLMETHODRESULT, do: quote(do: 707)
    # DataType
    defmacro ua_ns0id_CALLREQUEST, do: quote(do: 710)
    # DataType
    defmacro ua_ns0id_CALLRESPONSE, do: quote(do: 713)
    # DataType
    defmacro ua_ns0id_MONITORINGMODE, do: quote(do: 716)
    # DataType
    defmacro ua_ns0id_DATACHANGETRIGGER, do: quote(do: 717)
    # DataType
    defmacro ua_ns0id_DEADBANDTYPE, do: quote(do: 718)
    # DataType
    defmacro ua_ns0id_MONITORINGFILTER, do: quote(do: 719)
    # DataType
    defmacro ua_ns0id_DATACHANGEFILTER, do: quote(do: 722)
    # DataType
    defmacro ua_ns0id_EVENTFILTER, do: quote(do: 725)
    # DataType
    defmacro ua_ns0id_AGGREGATEFILTER, do: quote(do: 728)
    # DataType
    defmacro ua_ns0id_MONITORINGFILTERRESULT, do: quote(do: 731)
    # DataType
    defmacro ua_ns0id_EVENTFILTERRESULT, do: quote(do: 734)
    # DataType
    defmacro ua_ns0id_AGGREGATEFILTERRESULT, do: quote(do: 737)
    # DataType
    defmacro ua_ns0id_MONITORINGPARAMETERS, do: quote(do: 740)
    # DataType
    defmacro ua_ns0id_MONITOREDITEMCREATEREQUEST, do: quote(do: 743)
    # DataType
    defmacro ua_ns0id_MONITOREDITEMCREATERESULT, do: quote(do: 746)
    # DataType
    defmacro ua_ns0id_CREATEMONITOREDITEMSREQUEST, do: quote(do: 749)
    # DataType
    defmacro ua_ns0id_CREATEMONITOREDITEMSRESPONSE, do: quote(do: 752)
    # DataType
    defmacro ua_ns0id_MONITOREDITEMMODIFYREQUEST, do: quote(do: 755)
    # DataType
    defmacro ua_ns0id_MONITOREDITEMMODIFYRESULT, do: quote(do: 758)
    # DataType
    defmacro ua_ns0id_MODIFYMONITOREDITEMSREQUEST, do: quote(do: 761)
    # DataType
    defmacro ua_ns0id_MODIFYMONITOREDITEMSRESPONSE, do: quote(do: 764)
    # DataType
    defmacro ua_ns0id_SETMONITORINGMODEREQUEST, do: quote(do: 767)
    # DataType
    defmacro ua_ns0id_SETMONITORINGMODERESPONSE, do: quote(do: 770)
    # DataType
    defmacro ua_ns0id_SETTRIGGERINGREQUEST, do: quote(do: 773)
    # DataType
    defmacro ua_ns0id_SETTRIGGERINGRESPONSE, do: quote(do: 776)
    # DataType
    defmacro ua_ns0id_DELETEMONITOREDITEMSREQUEST, do: quote(do: 779)
    # DataType
    defmacro ua_ns0id_DELETEMONITOREDITEMSRESPONSE, do: quote(do: 782)
    # DataType
    defmacro ua_ns0id_CREATESUBSCRIPTIONREQUEST, do: quote(do: 785)
    # DataType
    defmacro ua_ns0id_CREATESUBSCRIPTIONRESPONSE, do: quote(do: 788)
    # DataType
    defmacro ua_ns0id_MODIFYSUBSCRIPTIONREQUEST, do: quote(do: 791)
    # DataType
    defmacro ua_ns0id_MODIFYSUBSCRIPTIONRESPONSE, do: quote(do: 794)
    # DataType
    defmacro ua_ns0id_SETPUBLISHINGMODEREQUEST, do: quote(do: 797)
    # DataType
    defmacro ua_ns0id_SETPUBLISHINGMODERESPONSE, do: quote(do: 800)
    # DataType
    defmacro ua_ns0id_NOTIFICATIONMESSAGE, do: quote(do: 803)
    # DataType
    defmacro ua_ns0id_MONITOREDITEMNOTIFICATION, do: quote(do: 806)
    # DataType
    defmacro ua_ns0id_DATACHANGENOTIFICATION, do: quote(do: 809)
    # DataType
    defmacro ua_ns0id_STATUSCHANGENOTIFICATION, do: quote(do: 818)
    # DataType
    defmacro ua_ns0id_SUBSCRIPTIONACKNOWLEDGEMENT, do: quote(do: 821)
    # DataType
    defmacro ua_ns0id_PUBLISHREQUEST, do: quote(do: 824)
    # DataType
    defmacro ua_ns0id_PUBLISHRESPONSE, do: quote(do: 827)
    # DataType
    defmacro ua_ns0id_REPUBLISHREQUEST, do: quote(do: 830)
    # DataType
    defmacro ua_ns0id_REPUBLISHRESPONSE, do: quote(do: 833)
    # DataType
    defmacro ua_ns0id_TRANSFERRESULT, do: quote(do: 836)
    # DataType
    defmacro ua_ns0id_TRANSFERSUBSCRIPTIONSREQUEST, do: quote(do: 839)
    # DataType
    defmacro ua_ns0id_TRANSFERSUBSCRIPTIONSRESPONSE, do: quote(do: 842)
    # DataType
    defmacro ua_ns0id_DELETESUBSCRIPTIONSREQUEST, do: quote(do: 845)
    # DataType
    defmacro ua_ns0id_DELETESUBSCRIPTIONSRESPONSE, do: quote(do: 848)
    # DataType
    defmacro ua_ns0id_REDUNDANCYSUPPORT, do: quote(do: 851)
    # DataType
    defmacro ua_ns0id_SERVERSTATE, do: quote(do: 852)
    # DataType
    defmacro ua_ns0id_REDUNDANTSERVERDATATYPE, do: quote(do: 853)
    # DataType
    defmacro ua_ns0id_SAMPLINGINTERVALDIAGNOSTICSDATATYPE, do: quote(do: 856)
    # DataType
    defmacro ua_ns0id_SERVERDIAGNOSTICSSUMMARYDATATYPE, do: quote(do: 859)
    # DataType
    defmacro ua_ns0id_SERVERSTATUSDATATYPE, do: quote(do: 862)
    # DataType
    defmacro ua_ns0id_SESSIONDIAGNOSTICSDATATYPE, do: quote(do: 865)
    # DataType
    defmacro ua_ns0id_SESSIONSECURITYDIAGNOSTICSDATATYPE, do: quote(do: 868)
    # DataType
    defmacro ua_ns0id_SERVICECOUNTERDATATYPE, do: quote(do: 871)
    # DataType
    defmacro ua_ns0id_SUBSCRIPTIONDIAGNOSTICSDATATYPE, do: quote(do: 874)
    # DataType
    defmacro ua_ns0id_MODELCHANGESTRUCTUREDATATYPE, do: quote(do: 877)
    # DataType
    defmacro ua_ns0id_RANGE, do: quote(do: 884)
    # DataType
    defmacro ua_ns0id_EUINFORMATION, do: quote(do: 887)
    # DataType
    defmacro ua_ns0id_EXCEPTIONDEVIATIONFORMAT, do: quote(do: 890)
    # DataType
    defmacro ua_ns0id_ANNOTATION, do: quote(do: 891)
    # DataType
    defmacro ua_ns0id_PROGRAMDIAGNOSTICDATATYPE, do: quote(do: 894)
    # DataType
    defmacro ua_ns0id_SEMANTICCHANGESTRUCTUREDATATYPE, do: quote(do: 897)
    # DataType
    defmacro ua_ns0id_EVENTNOTIFICATIONLIST, do: quote(do: 914)
    # DataType
    defmacro ua_ns0id_EVENTFIELDLIST, do: quote(do: 917)
    # DataType
    defmacro ua_ns0id_HISTORYEVENTFIELDLIST, do: quote(do: 920)
    # DataType
    defmacro ua_ns0id_HISTORYUPDATEEVENTRESULT, do: quote(do: 929)
    # DataType
    defmacro ua_ns0id_ISSUEDIDENTITYTOKEN, do: quote(do: 938)
    # DataType
    defmacro ua_ns0id_NOTIFICATIONDATA, do: quote(do: 945)
    # DataType
    defmacro ua_ns0id_AGGREGATECONFIGURATION, do: quote(do: 948)
    # DataType
    defmacro ua_ns0id_IMAGEBMP, do: quote(do: 2000)
    # DataType
    defmacro ua_ns0id_IMAGEGIF, do: quote(do: 2001)
    # DataType
    defmacro ua_ns0id_IMAGEJPG, do: quote(do: 2002)
    # DataType
    defmacro ua_ns0id_IMAGEPNG, do: quote(do: 2003)
    # ObjectType
    defmacro ua_ns0id_SERVERTYPE, do: quote(do: 2004)
    # ObjectType
    defmacro ua_ns0id_SERVERCAPABILITIESTYPE, do: quote(do: 2013)
    # ObjectType
    defmacro ua_ns0id_SERVERDIAGNOSTICSTYPE, do: quote(do: 2020)
    # ObjectType
    defmacro ua_ns0id_SESSIONSDIAGNOSTICSSUMMARYTYPE, do: quote(do: 2026)
    # ObjectType
    defmacro ua_ns0id_SESSIONDIAGNOSTICSOBJECTTYPE, do: quote(do: 2029)
    # ObjectType
    defmacro ua_ns0id_VENDORSERVERINFOTYPE, do: quote(do: 2033)
    # ObjectType
    defmacro ua_ns0id_SERVERREDUNDANCYTYPE, do: quote(do: 2034)
    # ObjectType
    defmacro ua_ns0id_TRANSPARENTREDUNDANCYTYPE, do: quote(do: 2036)
    # ObjectType
    defmacro ua_ns0id_NONTRANSPARENTREDUNDANCYTYPE, do: quote(do: 2039)
    # ObjectType
    defmacro ua_ns0id_BASEEVENTTYPE, do: quote(do: 2041)
    # ObjectType
    defmacro ua_ns0id_AUDITEVENTTYPE, do: quote(do: 2052)
    # ObjectType
    defmacro ua_ns0id_AUDITSECURITYEVENTTYPE, do: quote(do: 2058)
    # ObjectType
    defmacro ua_ns0id_AUDITCHANNELEVENTTYPE, do: quote(do: 2059)
    # ObjectType
    defmacro ua_ns0id_AUDITOPENSECURECHANNELEVENTTYPE, do: quote(do: 2060)
    # ObjectType
    defmacro ua_ns0id_AUDITSESSIONEVENTTYPE, do: quote(do: 2069)
    # ObjectType
    defmacro ua_ns0id_AUDITCREATESESSIONEVENTTYPE, do: quote(do: 2071)
    # ObjectType
    defmacro ua_ns0id_AUDITACTIVATESESSIONEVENTTYPE, do: quote(do: 2075)
    # ObjectType
    defmacro ua_ns0id_AUDITCANCELEVENTTYPE, do: quote(do: 2078)
    # ObjectType
    defmacro ua_ns0id_AUDITCERTIFICATEEVENTTYPE, do: quote(do: 2080)
    # ObjectType
    defmacro ua_ns0id_AUDITCERTIFICATEDATAMISMATCHEVENTTYPE, do: quote(do: 2082)
    # ObjectType
    defmacro ua_ns0id_AUDITCERTIFICATEEXPIREDEVENTTYPE, do: quote(do: 2085)
    # ObjectType
    defmacro ua_ns0id_AUDITCERTIFICATEINVALIDEVENTTYPE, do: quote(do: 2086)
    # ObjectType
    defmacro ua_ns0id_AUDITCERTIFICATEUNTRUSTEDEVENTTYPE, do: quote(do: 2087)
    # ObjectType
    defmacro ua_ns0id_AUDITCERTIFICATEREVOKEDEVENTTYPE, do: quote(do: 2088)
    # ObjectType
    defmacro ua_ns0id_AUDITCERTIFICATEMISMATCHEVENTTYPE, do: quote(do: 2089)
    # ObjectType
    defmacro ua_ns0id_AUDITNODEMANAGEMENTEVENTTYPE, do: quote(do: 2090)
    # ObjectType
    defmacro ua_ns0id_AUDITADDNODESEVENTTYPE, do: quote(do: 2091)
    # ObjectType
    defmacro ua_ns0id_AUDITDELETENODESEVENTTYPE, do: quote(do: 2093)
    # ObjectType
    defmacro ua_ns0id_AUDITADDREFERENCESEVENTTYPE, do: quote(do: 2095)
    # ObjectType
    defmacro ua_ns0id_AUDITDELETEREFERENCESEVENTTYPE, do: quote(do: 2097)
    # ObjectType
    defmacro ua_ns0id_AUDITUPDATEEVENTTYPE, do: quote(do: 2099)
    # ObjectType
    defmacro ua_ns0id_AUDITWRITEUPDATEEVENTTYPE, do: quote(do: 2100)
    # ObjectType
    defmacro ua_ns0id_AUDITHISTORYUPDATEEVENTTYPE, do: quote(do: 2104)
    # ObjectType
    defmacro ua_ns0id_AUDITUPDATEMETHODEVENTTYPE, do: quote(do: 2127)
    # ObjectType
    defmacro ua_ns0id_SYSTEMEVENTTYPE, do: quote(do: 2130)
    # ObjectType
    defmacro ua_ns0id_DEVICEFAILUREEVENTTYPE, do: quote(do: 2131)
    # ObjectType
    defmacro ua_ns0id_BASEMODELCHANGEEVENTTYPE, do: quote(do: 2132)
    # ObjectType
    defmacro ua_ns0id_GENERALMODELCHANGEEVENTTYPE, do: quote(do: 2133)
    # VariableType
    defmacro ua_ns0id_SERVERVENDORCAPABILITYTYPE, do: quote(do: 2137)
    # VariableType
    defmacro ua_ns0id_SERVERSTATUSTYPE, do: quote(do: 2138)
    # VariableType
    defmacro ua_ns0id_SERVERDIAGNOSTICSSUMMARYTYPE, do: quote(do: 2150)
    # VariableType
    defmacro ua_ns0id_SAMPLINGINTERVALDIAGNOSTICSARRAYTYPE, do: quote(do: 2164)
    # VariableType
    defmacro ua_ns0id_SAMPLINGINTERVALDIAGNOSTICSTYPE, do: quote(do: 2165)
    # VariableType
    defmacro ua_ns0id_SUBSCRIPTIONDIAGNOSTICSARRAYTYPE, do: quote(do: 2171)
    # VariableType
    defmacro ua_ns0id_SUBSCRIPTIONDIAGNOSTICSTYPE, do: quote(do: 2172)
    # VariableType
    defmacro ua_ns0id_SESSIONDIAGNOSTICSARRAYTYPE, do: quote(do: 2196)
    # VariableType
    defmacro ua_ns0id_SESSIONDIAGNOSTICSVARIABLETYPE, do: quote(do: 2197)
    # VariableType
    defmacro ua_ns0id_SESSIONSECURITYDIAGNOSTICSARRAYTYPE, do: quote(do: 2243)
    # VariableType
    defmacro ua_ns0id_SESSIONSECURITYDIAGNOSTICSTYPE, do: quote(do: 2244)
    # Object
    defmacro ua_ns0id_SERVER, do: quote(do: 2253)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERARRAY, do: quote(do: 2254)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACEARRAY, do: quote(do: 2255)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS, do: quote(do: 2256)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_STARTTIME, do: quote(do: 2257)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_CURRENTTIME, do: quote(do: 2258)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_STATE, do: quote(do: 2259)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_BUILDINFO, do: quote(do: 2260)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_BUILDINFO_PRODUCTNAME, do: quote(do: 2261)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_BUILDINFO_PRODUCTURI, do: quote(do: 2262)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_BUILDINFO_MANUFACTURERNAME, do: quote(do: 2263)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_BUILDINFO_SOFTWAREVERSION, do: quote(do: 2264)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_BUILDINFO_BUILDNUMBER, do: quote(do: 2265)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_BUILDINFO_BUILDDATE, do: quote(do: 2266)
    # Variable
    defmacro ua_ns0id_SERVER_SERVICELEVEL, do: quote(do: 2267)
    # Object
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES, do: quote(do: 2268)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_SERVERPROFILEARRAY, do: quote(do: 2269)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_LOCALEIDARRAY, do: quote(do: 2271)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_MINSUPPORTEDSAMPLERATE, do: quote(do: 2272)
    # Object
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS, do: quote(do: 2274)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY, do: quote(do: 2275)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_SERVERVIEWCOUNT, do: quote(do: 2276)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_CURRENTSESSIONCOUNT, do: quote(do: 2277)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_CUMULATEDSESSIONCOUNT, do: quote(do: 2278)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_SECURITYREJECTEDSESSIONCOUNT, do: quote(do: 2279)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_SESSIONTIMEOUTCOUNT, do: quote(do: 2281)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_SESSIONABORTCOUNT, do: quote(do: 2282)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_PUBLISHINGINTERVALCOUNT, do: quote(do: 2284)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_CURRENTSUBSCRIPTIONCOUNT, do: quote(do: 2285)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_CUMULATEDSUBSCRIPTIONCOUNT, do: quote(do: 2286)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_SECURITYREJECTEDREQUESTSCOUNT, do: quote(do: 2287)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_REJECTEDREQUESTSCOUNT, do: quote(do: 2288)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SAMPLINGINTERVALDIAGNOSTICSARRAY, do: quote(do: 2289)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SUBSCRIPTIONDIAGNOSTICSARRAY, do: quote(do: 2290)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_ENABLEDFLAG, do: quote(do: 2294)
    # Object
    defmacro ua_ns0id_SERVER_VENDORSERVERINFO, do: quote(do: 2295)
    # Object
    defmacro ua_ns0id_SERVER_SERVERREDUNDANCY, do: quote(do: 2296)
    # ObjectType
    defmacro ua_ns0id_STATEMACHINETYPE, do: quote(do: 2299)
    # ObjectType
    defmacro ua_ns0id_STATETYPE, do: quote(do: 2307)
    # ObjectType
    defmacro ua_ns0id_INITIALSTATETYPE, do: quote(do: 2309)
    # ObjectType
    defmacro ua_ns0id_TRANSITIONTYPE, do: quote(do: 2310)
    # ObjectType
    defmacro ua_ns0id_TRANSITIONEVENTTYPE, do: quote(do: 2311)
    # ObjectType
    defmacro ua_ns0id_AUDITUPDATESTATEEVENTTYPE, do: quote(do: 2315)
    # ObjectType
    defmacro ua_ns0id_HISTORICALDATACONFIGURATIONTYPE, do: quote(do: 2318)
    # ObjectType
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIESTYPE, do: quote(do: 2330)
    # ObjectType
    defmacro ua_ns0id_AGGREGATEFUNCTIONTYPE, do: quote(do: 2340)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_INTERPOLATIVE, do: quote(do: 2341)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_AVERAGE, do: quote(do: 2342)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_TIMEAVERAGE, do: quote(do: 2343)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_TOTAL, do: quote(do: 2344)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_MINIMUM, do: quote(do: 2346)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_MAXIMUM, do: quote(do: 2347)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_MINIMUMACTUALTIME, do: quote(do: 2348)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_MAXIMUMACTUALTIME, do: quote(do: 2349)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_RANGE, do: quote(do: 2350)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_ANNOTATIONCOUNT, do: quote(do: 2351)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_COUNT, do: quote(do: 2352)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_NUMBEROFTRANSITIONS, do: quote(do: 2355)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_START, do: quote(do: 2357)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_END, do: quote(do: 2358)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_DELTA, do: quote(do: 2359)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_DURATIONGOOD, do: quote(do: 2360)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_DURATIONBAD, do: quote(do: 2361)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_PERCENTGOOD, do: quote(do: 2362)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_PERCENTBAD, do: quote(do: 2363)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_WORSTQUALITY, do: quote(do: 2364)
    # VariableType
    defmacro ua_ns0id_DATAITEMTYPE, do: quote(do: 2365)
    # VariableType
    defmacro ua_ns0id_ANALOGITEMTYPE, do: quote(do: 2368)
    # VariableType
    defmacro ua_ns0id_DISCRETEITEMTYPE, do: quote(do: 2372)
    # VariableType
    defmacro ua_ns0id_TWOSTATEDISCRETETYPE, do: quote(do: 2373)
    # VariableType
    defmacro ua_ns0id_MULTISTATEDISCRETETYPE, do: quote(do: 2376)
    # ObjectType
    defmacro ua_ns0id_PROGRAMTRANSITIONEVENTTYPE, do: quote(do: 2378)
    # VariableType
    defmacro ua_ns0id_PROGRAMDIAGNOSTICTYPE, do: quote(do: 2380)
    # ObjectType
    defmacro ua_ns0id_PROGRAMSTATEMACHINETYPE, do: quote(do: 2391)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_MAXBROWSECONTINUATIONPOINTS, do: quote(do: 2735)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_MAXQUERYCONTINUATIONPOINTS, do: quote(do: 2736)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_MAXHISTORYCONTINUATIONPOINTS, do: quote(do: 2737)
    # ObjectType
    defmacro ua_ns0id_SEMANTICCHANGEEVENTTYPE, do: quote(do: 2738)
    # ObjectType
    defmacro ua_ns0id_AUDITURLMISMATCHEVENTTYPE, do: quote(do: 2748)
    # VariableType
    defmacro ua_ns0id_STATEVARIABLETYPE, do: quote(do: 2755)
    # VariableType
    defmacro ua_ns0id_FINITESTATEVARIABLETYPE, do: quote(do: 2760)
    # VariableType
    defmacro ua_ns0id_TRANSITIONVARIABLETYPE, do: quote(do: 2762)
    # VariableType
    defmacro ua_ns0id_FINITETRANSITIONVARIABLETYPE, do: quote(do: 2767)
    # ObjectType
    defmacro ua_ns0id_FINITESTATEMACHINETYPE, do: quote(do: 2771)
    # ObjectType
    defmacro ua_ns0id_CONDITIONTYPE, do: quote(do: 2782)
    # ObjectType
    defmacro ua_ns0id_REFRESHSTARTEVENTTYPE, do: quote(do: 2787)
    # ObjectType
    defmacro ua_ns0id_REFRESHENDEVENTTYPE, do: quote(do: 2788)
    # ObjectType
    defmacro ua_ns0id_REFRESHREQUIREDEVENTTYPE, do: quote(do: 2789)
    # ObjectType
    defmacro ua_ns0id_AUDITCONDITIONEVENTTYPE, do: quote(do: 2790)
    # ObjectType
    defmacro ua_ns0id_AUDITCONDITIONENABLEEVENTTYPE, do: quote(do: 2803)
    # ObjectType
    defmacro ua_ns0id_AUDITCONDITIONCOMMENTEVENTTYPE, do: quote(do: 2829)
    # ObjectType
    defmacro ua_ns0id_DIALOGCONDITIONTYPE, do: quote(do: 2830)
    # ObjectType
    defmacro ua_ns0id_ACKNOWLEDGEABLECONDITIONTYPE, do: quote(do: 2881)
    # ObjectType
    defmacro ua_ns0id_ALARMCONDITIONTYPE, do: quote(do: 2915)
    # ObjectType
    defmacro ua_ns0id_SHELVEDSTATEMACHINETYPE, do: quote(do: 2929)
    # ObjectType
    defmacro ua_ns0id_LIMITALARMTYPE, do: quote(do: 2955)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_SECONDSTILLSHUTDOWN, do: quote(do: 2992)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERSTATUS_SHUTDOWNREASON, do: quote(do: 2993)
    # Variable
    defmacro ua_ns0id_SERVER_AUDITING, do: quote(do: 2994)
    # Object
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_MODELLINGRULES, do: quote(do: 2996)
    # Object
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_AGGREGATEFUNCTIONS, do: quote(do: 2997)
    # ObjectType
    defmacro ua_ns0id_AUDITHISTORYEVENTUPDATEEVENTTYPE, do: quote(do: 2999)
    # ObjectType
    defmacro ua_ns0id_AUDITHISTORYVALUEUPDATEEVENTTYPE, do: quote(do: 3006)
    # ObjectType
    defmacro ua_ns0id_AUDITHISTORYDELETEEVENTTYPE, do: quote(do: 3012)
    # ObjectType
    defmacro ua_ns0id_AUDITHISTORYRAWMODIFYDELETEEVENTTYPE, do: quote(do: 3014)
    # ObjectType
    defmacro ua_ns0id_AUDITHISTORYATTIMEDELETEEVENTTYPE, do: quote(do: 3019)
    # ObjectType
    defmacro ua_ns0id_AUDITHISTORYEVENTDELETEEVENTTYPE, do: quote(do: 3022)
    # ObjectType
    defmacro ua_ns0id_EVENTQUEUEOVERFLOWEVENTTYPE, do: quote(do: 3035)
    # Object
    defmacro ua_ns0id_EVENTTYPESFOLDER, do: quote(do: 3048)
    # VariableType
    defmacro ua_ns0id_BUILDINFOTYPE, do: quote(do: 3051)
    # Object
    defmacro ua_ns0id_DEFAULTBINARY, do: quote(do: 3062)
    # Object
    defmacro ua_ns0id_DEFAULTXML, do: quote(do: 3063)
    # ReferenceType
    defmacro ua_ns0id_ALWAYSGENERATESEVENT, do: quote(do: 3065)
    # Variable
    defmacro ua_ns0id_ICON, do: quote(do: 3067)
    # Variable
    defmacro ua_ns0id_NODEVERSION, do: quote(do: 3068)
    # Variable
    defmacro ua_ns0id_LOCALTIME, do: quote(do: 3069)
    # Variable
    defmacro ua_ns0id_ALLOWNULLS, do: quote(do: 3070)
    # Variable
    defmacro ua_ns0id_ENUMVALUES, do: quote(do: 3071)
    # Variable
    defmacro ua_ns0id_INPUTARGUMENTS, do: quote(do: 3072)
    # Variable
    defmacro ua_ns0id_OUTPUTARGUMENTS, do: quote(do: 3073)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_SOFTWARECERTIFICATES, do: quote(do: 3704)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SERVERDIAGNOSTICSSUMMARY_REJECTEDSESSIONCOUNT, do: quote(do: 3705)
    # Object
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SESSIONSDIAGNOSTICSSUMMARY, do: quote(do: 3706)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SESSIONSDIAGNOSTICSSUMMARY_SESSIONDIAGNOSTICSARRAY, do: quote(do: 3707)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERDIAGNOSTICS_SESSIONSDIAGNOSTICSSUMMARY_SESSIONSECURITYDIAGNOSTICSARRAY, do: quote(do: 3708)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERREDUNDANCY_REDUNDANCYSUPPORT, do: quote(do: 3709)
    # ObjectType
    defmacro ua_ns0id_PROGRAMTRANSITIONAUDITEVENTTYPE, do: quote(do: 3806)
    # Method
    defmacro ua_ns0id_ADDCOMMENTMETHODTYPE, do: quote(do: 3863)
    # Method
    defmacro ua_ns0id_TIMEDSHELVEMETHODTYPE, do: quote(do: 6102)
    # DataType
    defmacro ua_ns0id_ENUMVALUETYPE, do: quote(do: 7594)
    # Variable
    defmacro ua_ns0id_MESSAGESECURITYMODE_ENUMSTRINGS, do: quote(do: 7595)
    # Variable
    defmacro ua_ns0id_COMPLIANCELEVEL_ENUMSTRINGS, do: quote(do: 7599)
    # Variable
    defmacro ua_ns0id_BROWSEDIRECTION_ENUMSTRINGS, do: quote(do: 7603)
    # Variable
    defmacro ua_ns0id_FILTEROPERATOR_ENUMSTRINGS, do: quote(do: 7605)
    # Variable
    defmacro ua_ns0id_TIMESTAMPSTORETURN_ENUMSTRINGS, do: quote(do: 7606)
    # Variable
    defmacro ua_ns0id_MONITORINGMODE_ENUMSTRINGS, do: quote(do: 7608)
    # Variable
    defmacro ua_ns0id_DATACHANGETRIGGER_ENUMSTRINGS, do: quote(do: 7609)
    # Variable
    defmacro ua_ns0id_REDUNDANCYSUPPORT_ENUMSTRINGS, do: quote(do: 7611)
    # Variable
    defmacro ua_ns0id_SERVERSTATE_ENUMSTRINGS, do: quote(do: 7612)
    # Variable
    defmacro ua_ns0id_EXCEPTIONDEVIATIONFORMAT_ENUMSTRINGS, do: quote(do: 7614)
    # DataType
    defmacro ua_ns0id_TIMEZONEDATATYPE, do: quote(do: 8912)
    # ObjectType
    defmacro ua_ns0id_LOCKTYPE, do: quote(do: 8921)
    # Object
    defmacro ua_ns0id_SERVERLOCK, do: quote(do: 8924)
    # Method
    defmacro ua_ns0id_SERVERLOCK_LOCK, do: quote(do: 8925)
    # Method
    defmacro ua_ns0id_SERVERLOCK_UNLOCK, do: quote(do: 8926)
    # ObjectType
    defmacro ua_ns0id_AUDITCONDITIONRESPONDEVENTTYPE, do: quote(do: 8927)
    # ObjectType
    defmacro ua_ns0id_AUDITCONDITIONACKNOWLEDGEEVENTTYPE, do: quote(do: 8944)
    # ObjectType
    defmacro ua_ns0id_AUDITCONDITIONCONFIRMEVENTTYPE, do: quote(do: 8961)
    # VariableType
    defmacro ua_ns0id_TWOSTATEVARIABLETYPE, do: quote(do: 8995)
    # VariableType
    defmacro ua_ns0id_CONDITIONVARIABLETYPE, do: quote(do: 9002)
    # ReferenceType
    defmacro ua_ns0id_HASTRUESUBSTATE, do: quote(do: 9004)
    # ReferenceType
    defmacro ua_ns0id_HASFALSESUBSTATE, do: quote(do: 9005)
    # ReferenceType
    defmacro ua_ns0id_HASCONDITION, do: quote(do: 9006)
    # Method
    defmacro ua_ns0id_CONDITIONREFRESHMETHODTYPE, do: quote(do: 9007)
    # Method
    defmacro ua_ns0id_DIALOGRESPONSEMETHODTYPE, do: quote(do: 9031)
    # ObjectType
    defmacro ua_ns0id_EXCLUSIVELIMITSTATEMACHINETYPE, do: quote(do: 9318)
    # ObjectType
    defmacro ua_ns0id_EXCLUSIVELIMITALARMTYPE, do: quote(do: 9341)
    # ObjectType
    defmacro ua_ns0id_EXCLUSIVELEVELALARMTYPE, do: quote(do: 9482)
    # ObjectType
    defmacro ua_ns0id_EXCLUSIVERATEOFCHANGEALARMTYPE, do: quote(do: 9623)
    # ObjectType
    defmacro ua_ns0id_EXCLUSIVEDEVIATIONALARMTYPE, do: quote(do: 9764)
    # ObjectType
    defmacro ua_ns0id_NONEXCLUSIVELIMITALARMTYPE, do: quote(do: 9906)
    # ObjectType
    defmacro ua_ns0id_NONEXCLUSIVELEVELALARMTYPE, do: quote(do: 10060)
    # ObjectType
    defmacro ua_ns0id_NONEXCLUSIVERATEOFCHANGEALARMTYPE, do: quote(do: 10214)
    # ObjectType
    defmacro ua_ns0id_NONEXCLUSIVEDEVIATIONALARMTYPE, do: quote(do: 10368)
    # ObjectType
    defmacro ua_ns0id_DISCRETEALARMTYPE, do: quote(do: 10523)
    # ObjectType
    defmacro ua_ns0id_OFFNORMALALARMTYPE, do: quote(do: 10637)
    # ObjectType
    defmacro ua_ns0id_TRIPALARMTYPE, do: quote(do: 10751)
    # ObjectType
    defmacro ua_ns0id_AUDITCONDITIONSHELVINGEVENTTYPE, do: quote(do: 11093)
    # ObjectType
    defmacro ua_ns0id_BASECONDITIONCLASSTYPE, do: quote(do: 11163)
    # ObjectType
    defmacro ua_ns0id_PROCESSCONDITIONCLASSTYPE, do: quote(do: 11164)
    # ObjectType
    defmacro ua_ns0id_MAINTENANCECONDITIONCLASSTYPE, do: quote(do: 11165)
    # ObjectType
    defmacro ua_ns0id_SYSTEMCONDITIONCLASSTYPE, do: quote(do: 11166)
    # ObjectType
    defmacro ua_ns0id_AGGREGATECONFIGURATIONTYPE, do: quote(do: 11187)
    # Object
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES, do: quote(do: 11192)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_ACCESSHISTORYDATACAPABILITY, do: quote(do: 11193)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_INSERTDATACAPABILITY, do: quote(do: 11196)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_REPLACEDATACAPABILITY, do: quote(do: 11197)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_UPDATEDATACAPABILITY, do: quote(do: 11198)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_DELETERAWCAPABILITY, do: quote(do: 11199)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_DELETEATTIMECAPABILITY, do: quote(do: 11200)
    # Object
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_AGGREGATEFUNCTIONS, do: quote(do: 11201)
    # Object
    defmacro ua_ns0id_HACONFIGURATION, do: quote(do: 11202)
    # Object
    defmacro ua_ns0id_HACONFIGURATION_AGGREGATECONFIGURATION, do: quote(do: 11203)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_AGGREGATECONFIGURATION_TREATUNCERTAINASBAD, do: quote(do: 11204)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_AGGREGATECONFIGURATION_PERCENTDATABAD, do: quote(do: 11205)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_AGGREGATECONFIGURATION_PERCENTDATAGOOD, do: quote(do: 11206)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_AGGREGATECONFIGURATION_USESLOPEDEXTRAPOLATION, do: quote(do: 11207)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_STEPPED, do: quote(do: 11208)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_DEFINITION, do: quote(do: 11209)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_MAXTIMEINTERVAL, do: quote(do: 11210)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_MINTIMEINTERVAL, do: quote(do: 11211)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_EXCEPTIONDEVIATION, do: quote(do: 11212)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_EXCEPTIONDEVIATIONFORMAT, do: quote(do: 11213)
    # Variable
    defmacro ua_ns0id_ANNOTATIONS, do: quote(do: 11214)
    # Variable
    defmacro ua_ns0id_HISTORICALEVENTFILTER, do: quote(do: 11215)
    # DataType
    defmacro ua_ns0id_MODIFICATIONINFO, do: quote(do: 11216)
    # DataType
    defmacro ua_ns0id_HISTORYMODIFIEDDATA, do: quote(do: 11217)
    # DataType
    defmacro ua_ns0id_HISTORYUPDATETYPE, do: quote(do: 11234)
    # VariableType
    defmacro ua_ns0id_MULTISTATEVALUEDISCRETETYPE, do: quote(do: 11238)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_ACCESSHISTORYEVENTSCAPABILITY, do: quote(do: 11242)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_MAXRETURNDATAVALUES, do: quote(do: 11273)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_MAXRETURNEVENTVALUES, do: quote(do: 11274)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_INSERTANNOTATIONCAPABILITY, do: quote(do: 11275)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_INSERTEVENTCAPABILITY, do: quote(do: 11281)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_REPLACEEVENTCAPABILITY, do: quote(do: 11282)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_UPDATEEVENTCAPABILITY, do: quote(do: 11283)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_TIMEAVERAGE2, do: quote(do: 11285)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_MINIMUM2, do: quote(do: 11286)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_MAXIMUM2, do: quote(do: 11287)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_RANGE2, do: quote(do: 11288)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_WORSTQUALITY2, do: quote(do: 11292)
    # DataType
    defmacro ua_ns0id_PERFORMUPDATETYPE, do: quote(do: 11293)
    # DataType
    defmacro ua_ns0id_UPDATESTRUCTUREDATADETAILS, do: quote(do: 11295)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_TOTAL2, do: quote(do: 11304)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_MINIMUMACTUALTIME2, do: quote(do: 11305)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_MAXIMUMACTUALTIME2, do: quote(do: 11306)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_DURATIONINSTATEZERO, do: quote(do: 11307)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_DURATIONINSTATENONZERO, do: quote(do: 11308)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERREDUNDANCY_CURRENTSERVERID, do: quote(do: 11312)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERREDUNDANCY_REDUNDANTSERVERARRAY, do: quote(do: 11313)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERREDUNDANCY_SERVERURIARRAY, do: quote(do: 11314)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_STANDARDDEVIATIONSAMPLE, do: quote(do: 11426)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_STANDARDDEVIATIONPOPULATION, do: quote(do: 11427)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_VARIANCESAMPLE, do: quote(do: 11428)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_VARIANCEPOPULATION, do: quote(do: 11429)
    # Variable
    defmacro ua_ns0id_ENUMSTRINGS, do: quote(do: 11432)
    # Variable
    defmacro ua_ns0id_VALUEASTEXT, do: quote(do: 11433)
    # ObjectType
    defmacro ua_ns0id_PROGRESSEVENTTYPE, do: quote(do: 11436)
    # ObjectType
    defmacro ua_ns0id_SYSTEMSTATUSCHANGEEVENTTYPE, do: quote(do: 11446)
    # VariableType
    defmacro ua_ns0id_OPTIONSETTYPE, do: quote(do: 11487)
    # Method
    defmacro ua_ns0id_SERVER_GETMONITOREDITEMS, do: quote(do: 11492)
    # Variable
    defmacro ua_ns0id_SERVER_GETMONITOREDITEMS_INPUTARGUMENTS, do: quote(do: 11493)
    # Variable
    defmacro ua_ns0id_SERVER_GETMONITOREDITEMS_OUTPUTARGUMENTS, do: quote(do: 11494)
    # Method
    defmacro ua_ns0id_GETMONITOREDITEMSMETHODTYPE, do: quote(do: 11495)
    # Variable
    defmacro ua_ns0id_MAXSTRINGLENGTH, do: quote(do: 11498)
    # Variable
    defmacro ua_ns0id_HISTORYSERVERCAPABILITIES_DELETEEVENTCAPABILITY, do: quote(do: 11502)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_STARTOFARCHIVE, do: quote(do: 11503)
    # Variable
    defmacro ua_ns0id_HACONFIGURATION_STARTOFONLINEARCHIVE, do: quote(do: 11504)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_STARTBOUND, do: quote(do: 11505)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_ENDBOUND, do: quote(do: 11506)
    # Object
    defmacro ua_ns0id_AGGREGATEFUNCTION_DELTABOUNDS, do: quote(do: 11507)
    # Object
    defmacro ua_ns0id_MODELLINGRULE_OPTIONALPLACEHOLDER, do: quote(do: 11508)
    # Variable
    defmacro ua_ns0id_MODELLINGRULE_OPTIONALPLACEHOLDER_NAMINGRULE, do: quote(do: 11509)
    # Object
    defmacro ua_ns0id_MODELLINGRULE_MANDATORYPLACEHOLDER, do: quote(do: 11510)
    # Variable
    defmacro ua_ns0id_MODELLINGRULE_MANDATORYPLACEHOLDER_NAMINGRULE, do: quote(do: 11511)
    # Variable
    defmacro ua_ns0id_MAXARRAYLENGTH, do: quote(do: 11512)
    # Variable
    defmacro ua_ns0id_ENGINEERINGUNITS, do: quote(do: 11513)
    # ObjectType
    defmacro ua_ns0id_OPERATIONLIMITSTYPE, do: quote(do: 11564)
    # ObjectType
    defmacro ua_ns0id_FILETYPE, do: quote(do: 11575)
    # ObjectType
    defmacro ua_ns0id_ADDRESSSPACEFILETYPE, do: quote(do: 11595)
    # ObjectType
    defmacro ua_ns0id_NAMESPACEMETADATATYPE, do: quote(do: 11616)
    # ObjectType
    defmacro ua_ns0id_NAMESPACESTYPE, do: quote(do: 11645)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_MAXARRAYLENGTH, do: quote(do: 11702)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_MAXSTRINGLENGTH, do: quote(do: 11703)
    # Object
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS, do: quote(do: 11704)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERREAD, do: quote(do: 11705)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERWRITE, do: quote(do: 11707)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERMETHODCALL, do: quote(do: 11709)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERBROWSE, do: quote(do: 11710)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERREGISTERNODES, do: quote(do: 11711)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERTRANSLATEBROWSEPATHSTONODEIDS, do: quote(do: 11712)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERNODEMANAGEMENT, do: quote(do: 11713)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXMONITOREDITEMSPERCALL, do: quote(do: 11714)
    # Object
    defmacro ua_ns0id_SERVER_NAMESPACES, do: quote(do: 11715)
    # Object
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE, do: quote(do: 11716)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_SIZE, do: quote(do: 11717)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_WRITEABLE, do: quote(do: 11718)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_USERWRITEABLE, do: quote(do: 11719)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_OPENCOUNT, do: quote(do: 11720)
    # Method
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_OPEN, do: quote(do: 11721)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_OPEN_INPUTARGUMENTS, do: quote(do: 11722)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_OPEN_OUTPUTARGUMENTS, do: quote(do: 11723)
    # Method
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_CLOSE, do: quote(do: 11724)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_CLOSE_INPUTARGUMENTS, do: quote(do: 11725)
    # Method
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_READ, do: quote(do: 11726)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_READ_INPUTARGUMENTS, do: quote(do: 11727)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_READ_OUTPUTARGUMENTS, do: quote(do: 11728)
    # Method
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_WRITE, do: quote(do: 11729)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_WRITE_INPUTARGUMENTS, do: quote(do: 11730)
    # Method
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_GETPOSITION, do: quote(do: 11731)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_GETPOSITION_INPUTARGUMENTS, do: quote(do: 11732)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_GETPOSITION_OUTPUTARGUMENTS, do: quote(do: 11733)
    # Method
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_SETPOSITION, do: quote(do: 11734)
    # Variable
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_SETPOSITION_INPUTARGUMENTS, do: quote(do: 11735)
    # Method
    defmacro ua_ns0id_SERVER_NAMESPACES_ADDRESSSPACEFILE_EXPORTNAMESPACE, do: quote(do: 11736)
    # DataType
    defmacro ua_ns0id_BITFIELDMASKDATATYPE, do: quote(do: 11737)
    # Method
    defmacro ua_ns0id_OPENMETHODTYPE, do: quote(do: 11738)
    # Method
    defmacro ua_ns0id_CLOSEMETHODTYPE, do: quote(do: 11741)
    # Method
    defmacro ua_ns0id_READMETHODTYPE, do: quote(do: 11743)
    # Method
    defmacro ua_ns0id_WRITEMETHODTYPE, do: quote(do: 11746)
    # Method
    defmacro ua_ns0id_GETPOSITIONMETHODTYPE, do: quote(do: 11748)
    # Method
    defmacro ua_ns0id_SETPOSITIONMETHODTYPE, do: quote(do: 11751)
    # ObjectType
    defmacro ua_ns0id_SYSTEMOFFNORMALALARMTYPE, do: quote(do: 11753)
    # ObjectType
    defmacro ua_ns0id_AUDITPROGRAMTRANSITIONEVENTTYPE, do: quote(do: 11856)
    # Object
    defmacro ua_ns0id_HACONFIGURATION_AGGREGATEFUNCTIONS, do: quote(do: 11877)
    # Variable
    defmacro ua_ns0id_NODECLASS_ENUMVALUES, do: quote(do: 11878)
    # DataType
    defmacro ua_ns0id_INSTANCENODE, do: quote(do: 11879)
    # DataType
    defmacro ua_ns0id_TYPENODE, do: quote(do: 11880)
    # Variable
    defmacro ua_ns0id_NODEATTRIBUTESMASK_ENUMVALUES, do: quote(do: 11881)
    # Variable
    defmacro ua_ns0id_ATTRIBUTEWRITEMASK_ENUMVALUES, do: quote(do: 11882)
    # Variable
    defmacro ua_ns0id_BROWSERESULTMASK_ENUMVALUES, do: quote(do: 11883)
    # DataType
    defmacro ua_ns0id_OPENFILEMODE, do: quote(do: 11939)
    # Variable
    defmacro ua_ns0id_OPENFILEMODE_ENUMVALUES, do: quote(do: 11940)
    # DataType
    defmacro ua_ns0id_MODELCHANGESTRUCTUREVERBMASK, do: quote(do: 11941)
    # Variable
    defmacro ua_ns0id_MODELCHANGESTRUCTUREVERBMASK_ENUMVALUES, do: quote(do: 11942)
    # DataType
    defmacro ua_ns0id_ENDPOINTURLLISTDATATYPE, do: quote(do: 11943)
    # DataType
    defmacro ua_ns0id_NETWORKGROUPDATATYPE, do: quote(do: 11944)
    # ObjectType
    defmacro ua_ns0id_NONTRANSPARENTNETWORKREDUNDANCYTYPE, do: quote(do: 11945)
    # VariableType
    defmacro ua_ns0id_ARRAYITEMTYPE, do: quote(do: 12021)
    # VariableType
    defmacro ua_ns0id_YARRAYITEMTYPE, do: quote(do: 12029)
    # VariableType
    defmacro ua_ns0id_XYARRAYITEMTYPE, do: quote(do: 12038)
    # VariableType
    defmacro ua_ns0id_IMAGEITEMTYPE, do: quote(do: 12047)
    # VariableType
    defmacro ua_ns0id_CUBEITEMTYPE, do: quote(do: 12057)
    # VariableType
    defmacro ua_ns0id_NDIMENSIONARRAYITEMTYPE, do: quote(do: 12068)
    # DataType
    defmacro ua_ns0id_AXISSCALEENUMERATION, do: quote(do: 12077)
    # Variable
    defmacro ua_ns0id_AXISSCALEENUMERATION_ENUMSTRINGS, do: quote(do: 12078)
    # DataType
    defmacro ua_ns0id_AXISINFORMATION, do: quote(do: 12079)
    # DataType
    defmacro ua_ns0id_XVTYPE, do: quote(do: 12080)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERHISTORYREADDATA, do: quote(do: 12165)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERHISTORYREADEVENTS, do: quote(do: 12166)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERHISTORYUPDATEDATA, do: quote(do: 12167)
    # Variable
    defmacro ua_ns0id_SERVER_SERVERCAPABILITIES_OPERATIONLIMITS_MAXNODESPERHISTORYUPDATEEVENTS, do: quote(do: 12168)
    # Variable
    defmacro ua_ns0id_VIEWVERSION, do: quote(do: 12170)
    # DataType
    defmacro ua_ns0id_COMPLEXNUMBERTYPE, do: quote(do: 12171)
    # DataType
    defmacro ua_ns0id_DOUBLECOMPLEXNUMBERTYPE, do: quote(do: 12172)
end

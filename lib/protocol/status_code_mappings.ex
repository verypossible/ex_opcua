defmodule ExOpcua.Protocol.StatusCodeMappings do
  @mappings %{
    2_149_253_120 =>
      {"Bad_CertificateRevocationUnknown",
       "It was not possible to determine if the certificate has been revoked"},
    2_149_711_872 =>
      {"Bad_SecureChannelIdInvalid", "The specified secure channel is no longer valid"},
    2_157_903_872 =>
      {"Bad_EntryExists",
       "The data or event was not successfully inserted because a matching entry exists"},
    2_149_974_016 => {"Bad_SessionClosed", "The session was closed by the client"},
    2_151_415_808 => {"Bad_OutOfRange", "The value was out of range"},
    3_014_656 => {"Good_CompletesAsynchronously", "The processing will complete asynchronously"},
    2_155_479_040 =>
      {"Bad_SequenceNumberUnknown", "The sequence number is unknown to the server"},
    2_154_168_320 =>
      {"Bad_DuplicateReferenceNotAllowed",
       "The reference type between the nodes is already defined"},
    2_147_942_400 =>
      {"Bad_DecodingError", "Decoding halted because of invalid data in the stream"},
    2_151_219_200 =>
      {"Bad_DataEncodingUnsupported",
       "The server does not support the requested data encoding for the node"},
    2_159_738_880 => {"Bad_EventNotAcknowledgeable", "The event cannot be acknowledged"},
    2_160_852_992 => {"Bad_ConditionAlreadyEnabled", "This condition has already been enabled"},
    2_148_007_936 =>
      {"Bad_EncodingLimitsExceeded",
       "The message encoding/decoding limits imposed by the stack have been exceeded"},
    2_148_335_616 =>
      {"Bad_ServerNotConnected",
       "The operation could not complete because the client is not connected to the server"},
    2_160_787_456 =>
      {"Bad_ViewVersionInvalid", "The view version is not available or not supported"},
    2_149_449_728 => {"Bad_CertificateIssuerRevoked", "The Issuer certificate has been revoked"},
    2_153_447_424 =>
      {"Bad_ParentNodeIdInvalid", "The parent node ID does not refer to a valid node"},
    2_152_988_672 =>
      {"Bad_SecurityModeRejected",
       "The security mode does not meet the requirements set by the server"},
    1_073_741_824 => {"Uncertain", "The value is uncertain but the reason is unknown"},
    2_158_821_376 => {"Bad_Disconnect", "The server has disconnected from the client"},
    1_083_441_152 =>
      {"Uncertain_EngineeringUnitsExceeded",
       "The value is outside of the range of values defined for this parameter"},
    2_160_721_920 =>
      {"Bad_ViewParameterMismatch", "The view parameters are not consistent with each other"},
    2_148_728_832 => {"Bad_SecurityChecksFailed", "An error occurred verifying security"},
    10_813_440 => {"Good_NoData", "No data exists for the requested time range or event filter"},
    2_158_886_912 => {"Bad_ConnectionClosed", "The network connection has been closed"},
    1_080_819_712 =>
      {"Uncertain_ReferenceOutOfServer",
       "One of the references to follow in the relative path references to a node in the address space in another server"},
    1_083_179_008 =>
      {"Uncertain_LastUsableValue", "Whatever was updating this value has stopped doing so"},
    2_156_003_328 => {"Bad_TcpInternalError", "An internal error occurred"},
    2_151_809_024 =>
      {"Bad_MonitoredItemIdInvalid",
       "The monitoring item ID does not refer to a valid monitored item"},
    2_161_508_352 =>
      {"Bad_AggregateInvalidInputs",
       "The aggregate value could not be derived due to invalid input data"},
    1_083_113_472 =>
      {"Uncertain_NoCommunicationLastUsableValue",
       "Communication to the data source has failed, The variable value is the last value that had a Good quality"},
    1_084_489_728 =>
      {"Uncertain_DataSubNormal",
       "The value is derived from multiple values and contains less than the required number of Good values"},
    2_159_280_128 =>
      {"Bad_ExpectedStreamToBlock",
       "The stream did not return all data requested (possibly because it is a non-blocking stream)"},
    2_149_908_480 => {"Bad_SessionIdInvalid", "The session ID is not valid"},
    2_156_593_152 =>
      {"Bad_DeviceFailure",
       "There has been a failure in the device/data source that generates the value that has affected the value"},
    2_150_367_232 => {"Bad_RequestCancelledByClient", "The request was cancelled by the client"},
    2_159_476_736 =>
      {"Bad_MaxConnectionsReached",
       "The operation could not be finished because all available connections are in use"},
    1_083_310_080 =>
      {"Uncertain_InitialValue",
       "The value is an initial value for a variable that normally receives its value from another variable"},
    2_157_772_800 => {"Bad_DataLost", "Data is missing due to collection started/stopped/lost"},
    2_152_202_240 => {"Bad_ContentFilterInvalid", "The content filter is not valid"},
    2_153_644_032 =>
      {"Bad_NodeIdExists", "The requested node ID is already used by another node"},
    2_155_741_184 =>
      {"Bad_TcpMessageTypeInvalid", "The type of the message specified in the header is invalid"},
    2_153_119_744 =>
      {"Bad_TooManySessions", "The server has reached its maximum number of sessions"},
    11_075_584 =>
      {"Good_CallAgain", "The operation is not finished and needs to be called again"},
    2_150_760_448 =>
      {"Bad_WaitingForInitialData",
       "Waiting for the server to obtain values from the underlying data source"},
    2_147_811_328 => {"Bad_CommunicationError", "A low level communication error occurred"},
    2_160_263_168 =>
      {"Bad_FilterOperandCountMismatch",
       "The number of operands provided for the filter operator was less than expected for the operand provided"},
    2_149_187_584 => {"Bad_CertificateUntrusted", "The certificate is not trusted"},
    2_154_823_680 => {"Bad_MaxAgeInvalid", "The max age parameter is invalid"},
    2_155_085_824 =>
      {"Bad_TypeMismatch",
       "The value supplied for the attribute is not of the same type as the attribute's value"},
    2_159_017_984 => {"Bad_EndOfStream", "Cannot move beyond end of the stream"},
    2_153_709_568 => {"Bad_NodeClassInvalid", "The node class is not valid"},
    2_155_216_896 =>
      {"Bad_ArgumentsMissing",
       "The client did not specify all of the input arguments for the method"},
    2_150_301_696 =>
      {"Bad_TimestampsToReturnInvalid", "The timestamps to return parameter are invalid"},
    2_157_379_584 =>
      {"Bad_RefreshInProgress",
       "This Condition refresh failed or a Condition refresh operation is already in progress"},
    2_155_544_576 =>
      {"Bad_MessageNotAvailable", "The requested notification message is no longer available"},
    2_155_151_360 =>
      {"Bad_MethodInvalid", "The method ID does not refer to a method for the specified object"},
    1_086_324_736 =>
      {"Uncertain_NotAllNodesAvailable",
       "The list of references may not be complete because the underlying system is not available"},
    2_161_442_816 =>
      {"Bad_AggregateNotSupported", "The requested Aggregate is not support by the server"},
    2_157_445_120 => {"Bad_ConditionAlreadyDisabled", "This condition has already been disabled"},
    2_154_102_784 =>
      {"Bad_TargetNodeIdInvalid", "The target node ID does not reference a valid node"},
    2_157_838_336 =>
      {"Bad_DataUnavailable",
       "Expected data is unavailable for the requested time range due to an unmounted volume, an offline archive or tape, or similar reason for temporary unavailability"},
    2_152_726_528 => {"Bad_ServerNameMissing", "No ServerName was specified"},
    0 => {"Good", "The operation was successful"},
    2_152_267_776 =>
      {"Bad_FilterOperandInvalid", "The operand used in a content filter is not valid"},
    2_152_464_384 => {"Bad_ReferenceTypeIdInvalid", "The reference type ID is not valid"},
    10_944_512 => {"Good_CommunicationEvent", "The communication layer has raised an event"},
    11_141_120 => {"Good_NonCriticalTimeout", "A non-critical timeout occurred"},
    2_147_483_648 => {"Bad", "The value is bad but the reason is unknown"},
    2_148_139_008 => {"Bad_Timeout", "The operation timed out"},
    2_151_481_344 => {"Bad_NotSupported", "The requested operation is not supported"},
    2_156_527_616 =>
      {"Bad_NotConnected",
       "The variable should receive its value from another variable but has never been configured to do so"},
    2_154_692_608 =>
      {"Bad_QueryTooComplex", "The requested operation requires too many resources on the server"},
    2_155_347_968 =>
      {"Bad_TooManyPublishRequests",
       "The server has reached the maximum number of queued publish requests"},
    2_161_311_744 =>
      {"Bad_ShelvingTimeOutOfRange", "The shelving time is not within an acceptable range"},
    2_153_250_816 =>
      {"Bad_ApplicationSignatureInvalid",
       "The signature generated with the client certificate is missing or invalid"},
    2_156_134_400 =>
      {"Bad_RequestInterrupted",
       "The request could not be sent because of a network interruption"},
    2_148_073_472 =>
      {"Bad_UnknownResponse", "An unrecognized response was received from the server"},
    2_152_005_632 =>
      {"Bad_FilterNotAllowed",
       "A monitoring filter cannot be used in combination with the attribute specified"},
    2_156_331_008 =>
      {"Bad_SecureChannelTokenUnknown", "The token has expired or is not recognized"},
    2_147_680_256 => {"Bad_OutOfMemory", "Not enough memory to complete the operation"},
    2_154_627_072 =>
      {"Bad_TooManyMatches", "The requested operation has too many matches to return"},
    2_148_466_688 =>
      {"Bad_NothingToDo",
       "There was nothing to do because the client passed a list of operations with no elements"},
    2_153_906_176 =>
      {"Bad_NodeAttributesInvalid", "The node attributes are not valid for the node class"},
    2_161_246_208 => {"Bad_ConditionNotShelved", "The condition is not currently shelved"},
    2_149_384_192 => {"Bad_CertificateRevoked", "The certificate has been revoked"},
    10_682_368 =>
      {"Good_EntryReplaced",
       "The data or event was successfully replaced in the historical database"},
    2_150_825_984 => {"Bad_NodeIdInvalid", "The syntax of the node ID is not valid"},
    2_150_039_552 =>
      {"Bad_SessionNotActivated",
       "The session cannot be used because ActivateSession has not been called"},
    2_151_874_560 =>
      {"Bad_MonitoredItemFilterInvalid", "The monitored item filter parameter is not valid"},
    2_150_957_056 =>
      {"Bad_AttributeIdInvalid", "The attribute is not supported for the specified node"},
    2_156_658_688 =>
      {"Bad_SensorFailure",
       "There has been a failure in the sensor from which the value is derived by the device/data source"},
    2_155_872_256 =>
      {"Bad_TcpMessageTooLarge", "The size of the message specified in the header is too large"},
    2_153_512_960 =>
      {"Bad_ReferenceNotAllowed",
       "The reference could not be created because it violates constraints imposed by the data model"},
    2_150_891_520 =>
      {"Bad_NodeIdUnknown",
       "The node ID refers to a node that does not exist in the server address space"},
    2_160_394_240 => {"Bad_FilterLiteralInvalid", "The referenced literal is not a valid value"},
    2_148_401_152 =>
      {"Bad_ServerHalted", "The server has stopped and cannot process any requests"},
    2_147_614_720 =>
      {"Bad_InternalError",
       "An internal error occurred as a result of a programming or configuration error"},
    2_155_675_648 =>
      {"Bad_TcpServerTooBusy", "The server cannot process the request because it is too busy"},
    2_152_923_136 => {"Bad_RequestTypeInvalid", "The security token request type is not valid"},
    2_154_364_928 => {"Bad_NoDeleteRights", "The server will not allow the node to be deleted"},
    2_151_677_952 => {"Bad_NotImplemented", "Requested operation is not implemented"},
    2_148_794_368 =>
      {"Bad_CertificateTimeInvalid", "The certificate has expired or is not yet valid"},
    3_145_728 => {"Good_Clamped", "The value written was accepted but was clamped"},
    2_149_318_656 =>
      {"Bad_CertificateIssuerRevocationUnknown",
       "It was not possible to determine if the Issuer certificate has been revoked"},
    2_154_954_752 =>
      {"Bad_HistoryOperationUnsupported", "The server does not support the requested operation"},
    2_154_889_216 =>
      {"Bad_HistoryOperationInvalid", "The history details parameter is not valid"},
    2_148_532_224 =>
      {"Bad_TooManyOperations",
       "The request could not be processed because it specified too many operations"},
    2_159_869_952 =>
      {"Bad_InvalidTimestampArgument", "The defined timestamp to return was invalid"},
    2_159_607_808 =>
      {"Bad_ResponseTooLarge", "The response message size exceeds limits set by the client"},
    2_159_411_200 => {"Bad_SyntaxError", "The value had an invalid syntax"},
    2_148_990_976 =>
      {"Bad_CertificateUriInvalid",
       "The URI specified in the ApplicationDescription does not match the URI in the certificate"},
    2_151_546_880 =>
      {"Bad_NotFound",
       "A requested item was not found or a search operation ended without success"},
    2_155_610_112 =>
      {"Bad_InsufficientClientProfile",
       "The Client of the current Session does not support one or more Profiles that are necessary for the Subscription"},
    2_154_430_464 => {"Bad_ServerIndexInvalid", "The server index is not valid"},
    2_152_136_704 => {"Bad_EventFilterInvalid", "The event filter is not valid"},
    2_155_020_288 =>
      {"Bad_WriteNotSupported",
       "The server does not support writing the combination of value status and timestamps provided"},
    2_152_857_600 =>
      {"Bad_SempahoreFileMissing", "The semaphore file specified by the client is not valid"},
    2_152_529_920 => {"Bad_BrowseDirectionInvalid", "The browse direction is not valid"},
    2_155_413_504 =>
      {"Bad_NoSubscription", "There is no subscription available for this session"},
    3_080_192 => {"Good_Overload", "Sampling has slowed down due to resource limitations"},
    2_152_660_992 => {"Bad_ServerUriInvalid", "The ServerUri is not a valid URI"},
    2_151_088_128 =>
      {"Bad_IndexRangeNoData", "No data exists within the range of indexes specified"},
    2_150_236_160 =>
      {"Bad_RequestHeaderInvalid", "The header for the request is missing or invalid"},
    1_083_375_616 => {"Uncertain_SensorNotAccurate", "The value is at one of the sensor limits"},
    2_152_333_312 =>
      {"Bad_ContinuationPointInvalid", "The continuation point is no longer valid"},
    10_878_976 =>
      {"Good_MoreData", "More data exists for the requested time range or event filter"},
    2_153_775_104 => {"Bad_BrowseNameInvalid", "The browse name is invalid"},
    2_147_745_792 => {"Bad_ResourceUnavailable", "An operating system resource is not available"},
    2_148_859_904 =>
      {"Bad_CertificateIssuerTimeInvalid",
       "An Issuer certificate has expired or is not yet valid"},
    2_149_842_944 =>
      {"Bad_NonceInvalid",
       "The nonce does appear to be not a random value or it is not the correct length"},
    2_156_724_224 => {"Bad_OutOfService", "The source of the data is not operational"},
    2_149_056_512 =>
      {"Bad_CertificateUseNotAllowed",
       "The certificate may not be used for the requested operation"},
    2_156_396_544 => {"Bad_SequenceNumberInvalid", "The sequence number is not valid"},
    2_153_316_352 =>
      {"Bad_NoValidCertificates",
       "The client did not provide at least one software certificate that is valid and meets the profile requirements for the server"},
    2_152_792_064 => {"Bad_DiscoveryUrlMissing", "No DiscoveryUrl was specified"},
    2_160_328_704 =>
      {"Bad_FilterElementInvalid",
       "The referenced element is not a valid element in the content filter"},
    2_154_037_248 =>
      {"Bad_SourceNodeIdInvalid", "The source node ID does not reference a valid node"},
    2_153_971_712 =>
      {"Bad_TypeDefinitionInvalid",
       "The type definition node ID does not reference an appropriate type node"},
    2_149_122_048 =>
      {"Bad_CertificateIssuerUseNotAllowed",
       "The Issuer certificate may not be used for the requested operation"},
    2_151_153_664 => {"Bad_DataEncodingInvalid", "The data encoding is invalid"},
    2_161_639_424 =>
      {"Bad_BoundNotSupported", "The server cannot retrieve a bound for the variable"},
    2_949_120 =>
      {"Good_SubscriptionTransferred", "The subscription was transferred to another session"},
    2_156_462_080 =>
      {"Bad_ConfigurationError",
       "There is a problem with the configuration that affects the usefulness of the value"},
    2_154_758_144 => {"Bad_NoMatch", "The requested operation has no match to return"},
    2_158_034_944 =>
      {"Bad_TimestampNotSupported",
       "The client requested history using a timestamp format the server does not support, In other words, the client requested ServerTimestamp when server only supports SourceTimestamp"},
    2_151_743_488 => {"Bad_MonitoringModeInvalid", "The monitoring mode is invalid"},
    2_148_270_080 =>
      {"Bad_Shutdown", "The operation was cancelled because the application is shutting down"},
    2_148_597_760 =>
      {"Bad_DataTypeIdUnknown",
       "The extension object cannot be (de)serialized because the data type ID is not recognized"},
    2_159_083_520 =>
      {"Bad_NoDataAvailable",
       "No data is currently available for reading from a non-blocking stream"},
    2_157_510_656 =>
      {"Bad_ConditionDisabled", "The property is not available or this condition is disabled"},
    1_083_506_688 =>
      {"Uncertain_SubNormal",
       "The value is derived from multiple sources and contains less than the required number of Good sources"},
    2_161_049_600 =>
      {"Bad_ConditionBranchAlreadyAcked", "The condition branch has already been acknowledged"},
    2_151_022_592 =>
      {"Bad_IndexRangeInvalid", "The syntax of the index range parameter is invalid"},
    2_159_149_056 =>
      {"Bad_WaitingForResponse", "The asynchronous operation is waiting for a response"},
    2_161_770_496 =>
      {"Bad_AggregateConfigurationRejected",
       "The aggregate configuration is not valid for the specified node"},
    2_152_595_456 => {"Bad_NodeNotInView", "The node is not part of the view"},
    2_160_459_776 =>
      {"Bad_IdentityChangeNotSupported",
       "The server does not support changing the user identity assigned to the session"},
    2_160_656_384 =>
      {"Bad_ViewTimestampInvalid", "The view timestamp is not available or not supported"},
    2_156_199_936 => {"Bad_RequestTimeout", "Timeout occurred while processing the request"},
    2_160_001_024 => {"Bad_StateNotActive", "The sub-state machine is not currently active"},
    2_153_578_496 =>
      {"Bad_NodeIdRejected",
       "The requested node ID was rejected because it was invalid or server does not allow node IDs to be specified by the client"},
    2_149_515_264 =>
      {"Bad_UserAccessDenied", "User does not have permission to perform the requested operation"},
    2_161_115_136 =>
      {"Bad_ConditionBranchAlreadyConfirmed", "The condition branch has already been confirmed"},
    2_151_612_416 =>
      {"Bad_ObjectDeleted", "The object cannot be used because it has been deleted"},
    2_149_580_800 => {"Bad_IdentityTokenInvalid", "The user identity token is not valid"},
    2_155_806_720 =>
      {"Bad_TcpSecureChannelUnknown",
       "The SecureChannelId and/or TokenId are not currently in use"},
    2_154_496_000 => {"Bad_ViewIdUnknown", "The view ID does not refer to a valid view node"},
    2_155_282_432 =>
      {"Bad_TooManySubscriptions", "The server has reached its maximum number of subscriptions"},
    2_150_105_088 => {"Bad_SubscriptionIdInvalid", "The subscription ID is not valid"},
    9_830_400 => {"Good_LocalOverride", "The value has been overridden"},
    2_147_549_184 => {"Bad_UnexpectedError", "An unexpected error occurred"},
    2_158_952_448 =>
      {"Bad_InvalidState",
       "The operation cannot be completed because the object is closed, uninitialized or in some other invalid state"},
    2_161_573_888 => {"Bad_BoundNotFound", "No data found to provide upper or lower bound value"},
    2_148_204_544 =>
      {"Bad_ServiceUnsupported", "The server does not support the requested service"},
    2_159_345_664 =>
      {"Bad_WouldBlock", "Non-blocking behavior is required and the operation would block"},
    2_151_350_272 => {"Bad_NotWritable", "The access level does not allow writing to the node"},
    2_155_937_792 =>
      {"Bad_TcpNotEnoughResources", "There are not enough resources to process the request"},
    2_153_381_888 =>
      {"Bad_RequestCancelledByRequest",
       "The request was cancelled by the client with the Cancel service"},
    14_221_312 =>
      {"Good_DataIgnored",
       "The request specifies fields which are not valid for the EventType or cannot be saved by the historian"},
    2_154_233_856 =>
      {"Bad_InvalidSelfReference",
       "The server does not allow this type of self-reference on this node"},
    2_147_876_864 =>
      {"Bad_EncodingError",
       "Encoding halted because of invalid data in the objects being serialized"},
    2_159_542_272 =>
      {"Bad_RequestTooLarge", "The request message size exceeds limits set by the server"},
    2_159_214_592 =>
      {"Bad_OperationAbandoned", "The asynchronous operation was abandoned by the caller"},
    2_149_646_336 =>
      {"Bad_IdentityTokenRejected",
       "The user identity token is valid but the server has rejected it"},
    10_616_832 =>
      {"Good_EntryInserted",
       "The data or event was successfully inserted into the historical database"},
    2_157_641_728 =>
      {"Bad_NoData", "No data exists for the requested time range or event filter"},
    2_153_185_280 =>
      {"Bad_UserSignatureInvalid", "The user token signature is missing or invalid"},
    2_160_197_632 =>
      {"Bad_FilterOperatorUnsupported",
       "A valid operator was provided but the server does not provide support for this filter operator"},
    2_156_789_760 => {"Bad_DeadbandFilterInvalid", "The deadband filter is not valid"},
    2_161_377_280 =>
      {"Bad_AggregateListMismatch",
       "The requested number of Aggregates does not match the requested number of node IDs"},
    12_189_696 =>
      {"Good_ResultsMayBeIncomplete",
       "The server should have followed a reference to a node in a remote server but did not, The result set may be incomplete"},
    2_161_836_032 =>
      {"Bad_TooManyMonitoredItems",
       "The request could not be processed because there are too many monitored items in the subscription"},
    2_160_590_848 =>
      {"Bad_NotTypeDefinition", "The provided node ID was not a type definition node ID"},
    2_152_398_848 =>
      {"Bad_NoContinuationPoints",
       "The operation could not be processed because all continuation points have been allocated"},
    2_160_984_064 => {"Bad_DialogResponseInvalid", "The response is not valid for the dialog"},
    11_010_048 => {"Good_ShutdownEvent", "The system is shutting down"},
    2_148_663_296 =>
      {"Bad_CertificateInvalid", "The certificate provided as a parameter is not valid"},
    1_083_244_544 =>
      {"Uncertain_SubstituteValue",
       "The value is an operational value that was manually overwritten"},
    2_157_576_192 => {"Bad_EventIdUnknown", "The specified event ID is not recognized"},
    2_156_068_864 =>
      {"Bad_TcpEndpointUrlInvalid", "The serverdoes not recognize the QueryString specified"},
    1_086_062_592 =>
      {"Uncertain_ReferenceNotDeleted", "The server was not able to delete all target references"},
    2_158_755_840 =>
      {"Bad_ConnectionRejected", "Could not establish a network connection to remote server"},
    2_149_777_408 =>
      {"Bad_InvalidTimestamp", "The timestamp is outside the range allowed by the server"},
    2_158_690_304 => {"Bad_InvalidArgument", "One or more arguments are invalid"},
    2_161_180_672 => {"Bad_ConditionAlreadyShelved", "The condition has already been shelved"},
    2_151_940_096 =>
      {"Bad_MonitoredItemFilterUnsupported",
       "The server does not support the requested monitored item filter"},
    2_160_918_528 => {"Bad_DialogNotActive", "The dialog condition is not active"},
    2_151_284_736 =>
      {"Bad_NotReadable", "The access level does not allow reading or subscribing to the node"},
    2_153_840_640 =>
      {"Bad_BrowseNameDuplicated",
       "The browse name is not unique among nodes that share the same relationship with the parent"},
    2_152_071_168 =>
      {"Bad_StructureMissing", "A mandatory structured parameter was missing or null"},
    2_156_265_472 => {"Bad_SecureChannelClosed", "The secure channel has been closed"},
    2_148_925_440 =>
      {"Bad_CertificateHostNameInvalid",
       "The HostName used to connect to a serverdoes not match a HostName in the certificate"},
    2_157_969_408 =>
      {"Bad_NoEntryExists",
       "The data or event was not successfully updated because no matching entry exists"},
    2_159_935_488 =>
      {"Bad_ProtocolVersionUnsupported",
       "The applications do not have compatible protocol versions"},
    2_154_299_392 =>
      {"Bad_ReferenceLocalOnly",
       "The reference type is not valid for a reference to a remote server"},
    2_160_132_096 =>
      {"Bad_FilterOperatorInvalid", "An unregognized operator was provided in a filter"},
    2_150_694_912 =>
      {"Bad_NoCommunication",
       "Communication with the data source is defined but not established and there is no last known value available"},
    2_153_054_208 =>
      {"Bad_SecurityPolicyRejected",
       "The security policy does not meet the requirements set by the server"}
  }

  def lookup(status), do: Map.get(@mappings, status, {"Unknown_Status", "code #{status}"})
end

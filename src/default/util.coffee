'use strict'
###
# Object util => methode util
# @autor: Jtutzo
# @version: 1.1
# @require jquery for ajax, moment for formatted date
###
util = (() -> 
    
    _private = {
        
        ###====================================================================================
        #                                     Constante
        #=====================================================================================###
        #Type variable
        UNDEFINED: 'undefined',
        NULL: 'null',
        BOOLEAN: 'boolean',
        NUMBER: 'number',
        STRING: 'string',
        OBJECT: 'object',
        ARRAY: 'array',
        FUNCTION: 'function',

        #Format date
        FORMAT_DATE_DD_MM_YYYY_1: 'DD/MM/YYYY',
        FORMAT_DATE_DD_MM_YY_1: 'DD/MM/YY',
        FORMAT_DATE_DD_MM_YYYY_2: 'DD-MM-YYYY',
        FORMAT_DATE_DD_MM_YY_2: 'DD-MM-YY',
        FORMAT_DATE_MM_DD_YYYY_1: 'MM/DD/YYYY',
        FORMAT_DATE_MM_DD_YY_1: 'MM/DD/YY',
        FORMAT_DATE_MM_DD_YYYY_2: 'MM-DD-YYYY',
        FORMAT_DATE_MM_DD_YY_2: 'MM-DD-YY',
        
        #regex for formatted date
        regexFormat: {
            'DD/MM/YYYY': [/(\d{2})\/(\d{2})\/(\d{4})/, "$2/$1/$3"],
            'DD/MM/YY': [/(\d{2})\/(\d{2})\/(\d{2})/, "$2/$1/$3"],
            'DD/MM/YYYY': [/(\d{2})-(\d{2})-(\d{4})/, "$2/$1/$3"],
            'DD/MM/YY': [/(\d{2})-(\d{2})-(\d{2})/, "$2/$1/$3"],
            'MM/DD/YYYY': [/(\d{2})\/(\d{2})\/(\d{4})/, "$1/$2/$3"],
            'MM/DD/YY': [/(\d{2})\/(\d{2})\/(\d{2})/, "$1/$2/$3"],
            'MM/DD/YYYY': [/(\d{2})-(\d{2})-(\d{4})/, "$1/$2/$3"],
            'MM/DD/YY': [/(\d{2})-(\d{2})-(\d{2})/, "$1/$2/$3"]
        },

        #Ajax response
        SUCCESS : 'SUCCESS',
        ERROR: 'ERROR',
        
        #Exceptions
        ARGUMENT_EXCEPTION: 'ArgumentException',

        NULL_OR_UNDEFINED_EXCEPTION: 'NullOrUndefinedException',
        NOT_NULL_OR_UNDEFINED_EXCEPTION: 'NotNullOrUndefinedException',

        NULL_EXCEPTION: 'NullException',
        NOT_NULL_EXCEPTION: 'NotNullException',

        UNDEFINED_EXCEPTION: 'UndefinedException',
        NOT_UNDEFINED_EXCEPTION: 'NotUndefinedException',

        BLANK_EXCEPTION: 'BlankException',
        NOT_BLANK_EXCEPTION: 'NotBlankException',

        EMPTY_EXCEPTION: 'EmptyException',
        NOT_EMPTY_EXCEPTION: 'NotEmptyException',

        BOOLEAN_EXCEPTION: 'BooleanException',
        NOT_BOOLEAN_EXCEPTION: 'NotBooleanException',

        NUMBER_EXCEPTION: 'NumberException',
        NOT_NUMBER_EXCEPTION: 'NotNumberException',

        STRING_EXCEPTION: 'StringException',
        NOT_STRING_EXCEPTION: 'NotStringException',

        OBJECT_EXCEPTION: 'ObjectException',
        NOT_OBJECT_EXCEPTION: 'NotObjectException',

        ARRAY_EXCEPTION: 'ArrayException',
        NOT_ARRAY_EXCEPTION: 'NotArrayException',

        FUNCTION_EXCEPTION: 'FunctionException',
        NOT_FUNCTION_EXCEPTION: 'NotFunctionException',

        #default params for ajax query
        defaultParamsAjax: {
            url: "",
            data: null,
            success: null,
            failure: null,
            method: 'POST',
            async: true
        },

        #params for ajax query
        paramsAjax: null,

        #default params for referentiel ajax query
        defaultParamsReferentiel: {
            url: "",
            repalceUrl: '{referentiel}',
            success: null,
            failure: null,
            method: 'POST',
            async: false
        },

        #params for referentiel ajax query
        paramsReferentiel: null,

        cacheReferentiel: [],

        #enable-disable mode debug
        isModeDebug: false,
        
        
        ###====================================================================================
        #                         methodes exception
        #===================================================================================###
        ###
        # launch exception (ARGUMENT_EXCEPTION) if expr is true
        # @param test
        # @param message
        ###
        argumentException: (expr, message) -> 
        
            if !_private.isBoolean expr 
                _private.error "util.argumentException => expr must be a boolean expression."
                throw new Error _private.ARGUMENT_EXCEPTION
            
            if !_private.isBlank message && !_private.isString message
                _private.error "util.argumentException => message must be a string value."
                throw new Error _private.ARGUMENT_EXCEPTION
                
            if expr 
                exception = _private.ARGUMENT_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.argumentException => expr is true [" + exception + "]"
                throw new Error _private.ARGUMENT_EXCEPTION
            else _private.debug "util.argumentException => expr is false."
                
        
        ###
        # Launch exception (NULL_OR_UNDEFINED_EXCEPTION) if value is null or unedfined
        # @param value
        # @param message
        ###
        nullOrUndefinedException: (value, message) -> 
            if _private.isNull value || _private.isUndefined value
                exception = _private.NULL_OR_UNDEFINED_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.nullOrUndefinedException => value is null or undefined [" + exception + "]"
                throw new Error _private.NULL_OR_UNDEFINED_EXCEPTION
            else _private.debug "util.nullException => value isn't null or unedfined."
       
        
        ###
        # Launch exception (NOT_NULL_OR_UNDEFINED_EXCEPTION) if value is null or unedfined
        # @param value
        # @param message
        ###
        notNullOrUndefinedException: (value, message) -> 
            if _private.isNotNull value || _private.isNotUndefined value 
                exception = _private.NOT_NULL_OR_UNDEFINED_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notNullOrUndefinedException => value isn't null or unedfined [" + exception + "]"
                throw new Error _private.NOT_NULL_OR_UNDEFINED_EXCEPTION
            else _private.debug "util.notNullOrUndefinedException => value is null or undefined."
        
        
        ###
        # Launch exception (NULL_EXCEPTION) if value is null
        # @param value
        # @param message
        ###
        nullException: (value, message) -> 
            if _private.isNull value 
                exception = _private.NULL_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.nullException => value is null [" + exception + "]"
                throw new Error _private.NULL_EXCEPTION
            else _private.debug "util.nullException => value isn't null."
        
        
        ###
        # Launch exception (NOT_NULL_EXCEPTION) if value isn't null
        # @param value
        # @param message
        ###
        notNullException: (value, message) -> 
            if _private.isNotNull value
                exception = _private.NOT_NULL_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notNullException => value isn't null [" + exception + "]"
                throw new Error _private.NOT_NULL_EXCEPTION
             else _private.debug "util.notNullException => value is null."
        
        
        ###
        # Launch exception (UNDEFINED_EXCEPTION) if value is undefined
        # @param value
        # @param message
        ###
        undefinedException: (value, message) -> 
            if _private.isUndefined value 
                exception = _private.UNDEFINED_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.undefinedException => value is unedfined [" + exception + "]"
                throw new Error _private.UNDEFINED_EXCEPTION
            else _private.debug "util.undefinedException => value isn't unedfined."
                
        
        ###
        # Launch exception (NOT_UNDEFINED_EXCEPTION) if value isn't undefined
        # @param value
        # @param message
        ###
        notUndefinedException: (value, message) -> 
            if _private.isNotUndefined value 
                exception = _private.NOT_UNDEFINED_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notUndefinedException => value isn't unedfined [" + exception + "]"
                throw new Error _private.NOT_UNDEFINED_EXCEPTION
            else _private.debug "util.notUndefinedException => value is unedfined."
        
        
        ###
        # Launch exception (BLANK_EXCEPTION) if value is blank
        # @param value
        # @param message
        ###
        blankException: (value, message) -> 
            if _private.isBlank value 
                exception = _private.BLANK_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.blankException => value is blank [" + exception + "]"
                throw new Error _private.BLANK_EXCEPTION
            else _private.debug "util.blankException => value isn't blank."
        
        
        ###
        # Launch exception (NOT_BLANK_EXCEPTION) if value is blank
        # @param value
        # @param message
        ###
        notBlankException: (value, message) -> 
            if _private.isNotBlank value
                exception = _private.NOT_BLANK_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notBlankException => value isn't blank [" + exception + "]"
                throw new Error _private.NOT_BLANK_EXCEPTION
            else _private.debug "util.notBlankException => value is blank."
        
        
        ###
        # Launch exception (EMPTY_EXCEPTION) if value is empty
        # @param value
        # @param message
        ###
        emptyException: (value, message) -> 
            if _private.isEmpty value
                exception = _private.EMPTY_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.emptyException => value is empty [" + exception + "]"
                throw new Error _private.EMPTY_EXCEPTION
            else _private.debug "util.emptyException => value isn't empty."
        
        
        ###
        # Launch exception (NOT_EMPTY_EXCEPTION) if value isn't empty
        # @param value
        # @param message
        ###
        notEmptyException: (value, message) -> 
            if _private.isNotEmpty value
                exception = _private.NOT_EMPTY_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notEmptyException => value isn't empty [" + exception + "]"
                throw new Error _private.NOT_EMPTY_EXCEPTION
            else _private.debug "util.notEmptyException => value is empty."
        
        
        ###
        # launch exception (BOOLEAN_EXCEPTION) if is a boolean value
        # @param value
        # @param message
        ###
        booleanException: (value, message) -> 
            if _private.isBoolean value
                exception = _private.BOOLEAN_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.booleanException => value is a boolean [" + exception + "]"
                throw new Error _private.BOOLEAN_EXCEPTION
            else _private.debug "util.booleanException => value isn't a boolean."
        
        
        ###
        * launch exception (NOT_BOOLEAN_EXCEPTION) if isn't a boolean value
        * @param value
        * @param message
        ###
        notBooleanException: (value, message) -> 
            if _private.isNotBoolean value
                exception = _private.NOT_BOOLEAN_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notBooleanException => value isn't a boolean [" + exception + "]"
                throw new Error _private.NOT_BOOLEAN_EXCEPTION
            else _private.debug "util.notBooleanException => value is a boolean."
        
        
        ###
        # launch exception (NUMBER_EXCEPTION) if is a number value
        # @param value
        # @param message
        ###
        numberException: (value, message) -> 
            if _private.isNumber value
                exception = _private.NUMBER_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.numberException => value is a number [" + exception + "]"
                throw new Error _private.NUMBER_EXCEPTION
            else _private.debug "util.numberException => value isn't a number."
                
                
        ###
        # launch exception (NOT_NUMBER_EXCEPTION) if isn't a number value
        # @param value
        # @param message
        ###
        notNumberException: (value, message) -> 
            if _private.isNotNumber value
                exception = _private.NOT_NUMBER_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notNumberException => value isn't a number [" + exception + "]"
                throw new Error _private.NOT_NUMBER_EXCEPTION
            else _private.debug "util.notNumberException => value is a number."
                
                
        ###
        # launch exception (STRING_EXCEPTION) if is a string value
        # @param value
        # @param message
        ###
        stringException: (value, message) -> 
            if _private.isString value
                exception = _private.STRING_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.stringException => value is a string [" + exception + "]"
                throw new Error _private.STRING_EXCEPTION
            else _private.debug "util.stringException => value isn't a string."
                
        
        ###
        # launch exception (NOT_STRING_EXCEPTION) if isn't a string value
        # @param value
        # @param message
        ###
        notStringException: (value, message) -> 
            if _private.isNotString value
                exception = _private.NOT_STRING_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notStringException => value isn't a string [" + exception + "]"
                throw new Error _private.NOT_STRING_EXCEPTION
            else _private.debug "util.notStringException => value is a string."
        
        
        ###
        # launch exception (OBJECT_EXCEPTION) if is an object value
        # @param value
        # @param message
        ###
        objectException: (value, message) -> 
            if _private.isObject value
                exception = _private.OBJECT_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.objectException => value is an object [" + exception + "]"
                throw new Error _private.OBJECT_EXCEPTION
            else_private.debug"util.objectException => value isn't an object."
            
        
        ###
        # launch exception (NOT_OBJECT_EXCEPTION) if isn't an object value
        # @param value
        # @param message
        ###
        notObjectException: (value, message) -> 
            if _private.isNotObject value
                exception = _private.NOT_OBJECT_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notObjectException => value isn't an object [" + exception + "]"
                throw new Error _private.NOT_OBJECT_EXCEPTION
            else _private.debug "util.notObjectException => value is an object."
        
        
        ###
        # launch exception (ARRAY_EXCEPTION) if isn't an array value
        # @param value
        # @param message
        ###
        arrayException: (value, message) -> 
            if _private.isArray value
                exception = _private.ARRAY_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.arrayException => value is an array [" + exception + "]"
                throw new Error _private.ARRAY_EXCEPTION
            else _private.debug "util.arrayException => value isn't an array."
                
        
        ###
        # launch exception (NOT_ARRAY_EXCEPTION) if isn't an array value
        # @param value
        # @param message
        ###
        notArrayException: (value, message) -> 
            if _private.isNotArray value
                exception = _private.NOT_ARRAY_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notArrayException => value isn't an array [" + exception + "]"
                throw new Error _private.NOT_ARRAY_EXCEPTION
            else _private.debug "util.notArrayException => value is an array."
                
                
        ###
        # launch exception (FUNCTION_EXCEPTION) if isn't a function value
        # @param value
        # @param message
        ###
        functionException: (value, message) -> 
            if _private.isFunction value
                exception = _private.FUNCTION_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.functionException => value is a function [" + exception + "]"
                throw new Error _private.FUNCTION_EXCEPTION
            else _private.debug "util.functionException => value isn't a function."
                
        
        ###
        # launch exception (NOT_FUNCTION_EXCEPTION) if isn't a function value
        # @param value
        # @param message
        ###
        notFunctionException: (value, message) -> 
            if _private.isNotFunction value
                exception = _private.NOT_FUNCTION_EXCEPTION + if !_private.isBlank message then ": " + message else "."
                _private.error "util.notFunctionException => value isn't a function [" + exception + "]"
                throw new Error _private.NOT_FUNCTION_EXCEPTION
            else _private.debug "util.notFunctionException => value is a function."
        
        
        ###====================================================================================
        #                         methodes exception
        #===================================================================================###
        ###
        # Check if is null or undefined value
        # @param value
        ###
        isNullOrUndefined: (value) -> 
            if (_private.isNull value) or (_private.isUndefined value)
                _private.debug "util.isNullOrUndefined => value is null or undefined.";true
            else _private.debug "util.isNullOrUndefined => value isn't null and undefined.";false
        
        
        ###
        * Check if isn't null or undefined value
        * @param value
        ###
        isNotNullOrUndefined: (value) -> !_private.isNullOrUndefined value
        
        
        ###
        # Check if is null, undefined or blank value
        # @param value
        ###
        isBlank: (value) -> 
            if (_private.isNull value) or (_private.isUndefined value) or ((_private.isString value) and value.trim is 0)
                _private.debug "util.isBlank => value is blank.";true
            else _private.debug "util.isBlank => value isn't blank.";false
        
        
        ###
        # Check if isn't null, undefined or blank value
        # @param value
        ###
        isNotBlank: (value) -> !_private.isBlank value
        
        
        ###
        # Check if value is null, undefined, blank or empty
        # @param value
        ###
        isEmpty: (value) -> 
            if (_private.isBlank value) or ((_private.isObject value) and Object.keys(value).length is 0) or ((_private.isArray value) and value.length is 0)
                _private.debug "util.isEmpty => value is empty.";true
            else _private.debug "util.isEmpty => value isn't empty.";false
        
        
        ###
        # Check if value isn't null, undefined, blank or empty
        # @param value
        ###
        isNotEmpty: (value) -> !_private.isEmpty value
        
        
        ###
        # Check if at least values is empty
        # @param values (array)
        # @exception NOT_ARRAY_EXCEPTION
        ###
        oneIsEmpty: (array) -> 
            _private.notArrayException array, "array must be an array value (util.oneIsEmpty)."
            for value in array
                if _private.isEmpty value then _private.debug "util.oneIsEmpty => at least value is empty.";return true
            _private.debug "util.oneIsEmpty => any value is empty.";false
        
        
        ###
        # Check if value1 and value2 are equals
        # Caution : use JSON for camparaison !
        # @param value1
        # @param value2
        ###
        isEquals: (value1, value2) -> 
            if JSON.stringify(obj1) is JSON.stringify(obj2) then _private.debug "util.isEquals => value1 is equal to value2.";true;
            else _private.debug "util.isEquals => value1 isn't equal to value2.";false
        
        
        ###
        # Check if at least value is equals
        # @param array1
        # @param array2
        # @exception NOT_ARRAY_EXCEPTION
        ###
        oneIsEquals: (array1, array2) -> 
            _private.notArrayException array1, "array1 must be an array value (util.oneIsEquals)."
            _private.notArrayException array2, "array2 must be an array value (util.oneIsEquals)."
            for value1 in array1
                for value2 in array2
                    if value1 is value2 then _private.debug "util.oneIsEquals => at least value are equals.";return true
            _private.debug "util.oneIsEquals => no value are equals.";false
        
        
        ###
        # Check if array contain seq
        # @param array
        # @param seq
        # @exception NOT_ARRAY_EXCEPTION
        ###
        contain: (array, seq) -> 
            _private.notArrayException array, "array must be an array value."
            for value in array
                if (util.isObject seq) and (JSON.stringify(value) is JSON.stringify seq) then return true
                else if value is seq then return true
            false
        
        
        ###
        * Check if array no contain seq
        * @param array
        * @param seq
        * @exception NOT_ARRAY_EXCEPTION
        ###
        noContain: (array, seq) -> !_private.contain array, seq
        
        
        ###
        * clone an element
        * @param element
        * @exception UNDEFINED_EXCEPTION, FUNCTION_EXCEPTION
        ###
        clone: (element) -> 
            _private.undefinedException element, "element mustn't be undefined (util.clone)"
            _private.functionException element, "element mustn't be a function (util.clone)"
            _private.debug "util.clone => clone element #{element}"
            JSON.parse JSON.stringify element
        
        
        ###====================================================================================
        #                            methode check or get type
        #===================================================================================###
        ###
        # Check if value is null
        # @param value
        ###
        isNull: (value) -> 
            if value is null then _private.debug "util.isNull => value is null.";true
            else _private.debug "util.isNull => value isn't null.";false
        
        
        ###
        # Check if value isn't null
        # @param value
        ###
        isNotNull: (value) -> !_private.isNull value
        
        
        ###
        # Check if value is undefined
        # @param value
        ###
        isUndefined: (value) -> 
            if value is undefined then _private.debug "util.isUndefined => value is undefined.";true
            else _private.debug "util.isUndefined => value isn't undefined.";false
        
        
        ###
        # Check if value isn't undefined
        # @param value
        ###
        isNotUndefined: (value) -> !_private.isUndefined value
        
        
        ###
        # Check if value is a boolean
        # @param value
        # @return boolean
        ###
        isBoolean: (value) -> 
            if (_private.isNullOrUndefined value) or (typeof value isnt _private.BOOLEAN)
                _private.debug "util.isBoolean => value isn't a boolean.";false
            else _private.debug "util.isBoolean => value is a boolean.";true
        
        
        ###
        # Check if value isn't a boolean
        # @param value
        # @return boolean
        ###
        isNotBoolean: (value) -> !_private.isBoolean value
        
        
        ###
        # Check if value is a number
        # @param value
        # @return boolean
        ###
        isNumber: (value) -> 
            if (_private.isNullOrUndefined value) or (typeof value isnt _private.NUMBER)
                _private.debug"util.isNumber => value isn't a number.";false
            else _private.debug "util.isNumber => value is a number.";true
                
        
        ###
        # Check if value isn't a number
        # @param value
        # @return boolean
        ###
        isNotNumber: (value) -> !_private.isNumber value
        
        
        ###
        # Check if is a string value
        # @param value
        # @return boolean
        ###
        isString: (value) -> 
            if (_private.isNullOrUndefined value) or (typeof value isnt _private.STRING)
                _private.debug "util.isString => value isn't a string.";false
            else _private.debug "util.isString => value is a string.";true
        
        
        ###
        # Check if isn't a string value
        # @param value
        # @return boolean
        ###
        isNotString: (value) -> !_private.isString value
        
        
        ###
        # Check if is an object value
        # Caution : array is not object !
        # @param value
        # @return boolean
        ###
        isObject: (value) -> 
            if (_private.isNullOrUndefined value) or (typeof value isnt _private.OBJECT) or _private.isArray value 
                _private.debug "util.isObject => value isn't an object.";false
            else _private.debug "util.isObject => value is an object.";true
        
        
        ###
        # Check if isn't an object value
        # Caution : array is not object !
        # @param value
        # @return boolean
        ###
        isNotObject: (value) -> !_private.isObject value
        
        
        ###
        # Check if is an array value
        # @param value
        # @return boolean
        ###
        isArray: (value) -> 
            if (_private.isNullOrUndefined value) or !Array.isArray value
                _private.debug"util.isArray => value isn't an array.";false
            else _private.debug "util.isArray => value is an array.";true
        
        
        ###
        # Check if isn't an array value
        # @param value
        # @return boolean
        ###
        isNotArray: (value) -> !_private.isArray value
        
        
        ###
        # Check if is a function value
        # @param value
        # @return boolean
        ###
        isFunction: (value) -> 
            if (_private.isNullOrUndefined value) or (typeof value isnt _private.FUNCTION)
                _private.debug "util.isFunction => value isn't a function.";false
            else _private.debug "util.isFunction => value is a function.";true
        
        
        ###
        # Check if isn't a function value
        # @param value
        # @return boolean
        ###
        isNotFunction: (value) -> !_private.isFunction value
        
        
        ###
        # Get type name of value
        # @param value
        # @return String (type name)
        # @exception if type is unknow
        ###
        getType: (value) -> 
            if _private.isUndefined value then _private.debug "util.getType => value is " + _private.UNDEFINED + ".";_private.UNDEFINED
            else if _private.isNull value then _private.debug "util.getType => value is " + _private.NULL + ".";_private.NULL
            else if _private.isBoolean value then _private.debug "util.getType => value is " + _private.BOOLEAN + ".";_private.BOOLEAN
            else if _private.isNumber value then _private.debug "util.getType => value is " + _private.NUMBER + ".";_private.NUMBER
            else if _private.isString value then _private.debug "util.getType => value is " + _private.STRING + ".";_private.STRING
            else if _private.isObject value then _private.debug "util.getType => value is " + _private.OBJECT + ".";_private.OBJECT
            else if _private.isArray value then _private.debug "util.getType => value is " + _private.ARRAY + ".";_private.ARRAY
            else if _private.isFunction value then _private.debug "util.getType => value is " + _private.FUNCTION + ".";_private.FUNCTION
            else _private.error "util.getType => type unknow.";throw new Error "util.getType => type unknow."

        
        ###====================================================================================
        #                                   methodes ajax
        #===================================================================================###
        ###
        * configure ajax query
        * @param params
        * @param isDefaultParams
        * @exception NOT_OBJECT_EXCEPTION, ARGUMENT_EXCEPTION
        ###
        confAjax: (conf, isDefaultConf) -> 

            _private.notObjectException conf, "params must be an object value (util.confAjax)."

            expr = (_private.isNotNullOrUndefined isDefaultConf) and _private.isNotBoolean isDefaultConf
            _private.argumentException expr, "isDefaultConf must be a null, undefined or boolean value (util.confAjax)."

            _private['paramsAjax'] = _private.factoryConfAjax conf, _private['defaultParamsAjax']

            if isDefaultConf is true then _private['defaultParamsAjax'] = _private.clone _private['paramsAjax']
        
        
        ###
        * Send ajax query 
        * @param url
        * @param data
        * @param success
        * @param failure
        ###
        ajax: (url, data, success, failure) -> 

            _private.confAjax {
                url: url,
                data: data,
                success: success,
                failure: failure
            }

            _private.query _private['paramsAjax']
    
        
        ###
        * factory conf ajax query
        * @param conf
        * @param defaultConf
        * @private
        * @exception NOT_OBJECT_EXCEPTION, EMPTY_EXCEPTION, NOT_STRING_EXCEPTION, NOT_BOOLEAN_EXCEPTION, ARGUMENT_EXCEPTION
        ###
        factoryConfAjax: (conf, defaultConf) -> 

            _private.notObjectException conf, "conf must be an object value (util.factoryParamsAjax)."
            _private.notObjectException defaultConf, "defaultConf must be an object (util.factoryParamsAjax)."
            _private.emptyException defaultConf, "defaultConf mustn't be an empty object (util.factoryParamsAjax)."

            retour = _private.clone defaultConf

            #url
            if _private.isNotNullOrUndefined conf['url'] 
                _private.notStringException conf['url'], "conf.url must be a string value (util.factoryParamsAjax)."
                retour['url'] = conf['url'];
            
            #data
            if _private.isNotUndefined conf['data']
                expr = (_private.isNotNull conf['data']) and _private.isNotObject conf['data']
                _private.argumentException expr, "conf.data must be a null or an object value (util.factoryParamsAjax)."
                retour['data'] = _private.clone conf['data']

            #success
            if _private.isNotUndefined conf['success']
                expr = (_private.isNotNull conf['success']) and _private.isNotFunction conf['success']
                _private.argumentException expr, "conf.success must be a null or a function value (util.factoryParamsAjax)."
                retour['success'] = conf['success']

            #failure
            if _private.isNotUndefined conf['failure']
                expr = (_private.isNotNull conf['failure']) && _private.isNotFunction conf['failure']
                _private.argumentException expr, "conf.failure must be a null or a function value (util.factoryParamsAjax)."
                retour['failure'] = conf['failure']

            #method
            if _private.isNotNullOrUndefined conf['method']
                _private.notStringException conf['method'], "conf.method must be a string value (util.factoryParamsAjax)."
                expr = conf['method'] isnt 'POST' && conf['method'] isnt 'GET'
                _private.argumentException expr, "conf.methode must be equals to 'GET' or 'POST' (util.factoryParamsAjax)."
                retour['method'] = conf['method'];

            #async
            if _private.isNotNullOrUndefined conf['async']
                _private.notBooleanException conf['async'], "conf.async must be a boolean value (util.factoryParamsAjax)."
                retour['async'] = conf['async'];

            retour;
            
        
        ###
        * Send query with ajax jquery lib 
        * @param options
        ###
        query: (options) -> 
            success = (obj) -> _private.debug "Response : #{obj}";options.success?(obj)
            failure = (obj) -> _private.error "error : #{obj}";options.failure?(obj)
            
            util.notObjectException options, "options must be an object value (util.query)."
            $.ajaxSetup {async: (if options.async then true else false)}
            
            _private.debug options.method + " " + options.url + " [data : " + option.data + "]"
            $.ajax {type: options.method, url : options.url, data : options.data}
            .done (response) -> 
                try
                    if reponse? and _private.isNotUndefined reponse
                        obj = _private.toObject response
                    
                        if !obj then throw "No data received";
                        else if obj.typeMessage == _private.SUCCESS then success(obj)
                        else failure?(obj)
                    else failure?(obj)
                catch e then _private.error "exception : " + exception + " [response : " + response +"]"
            .fail (jqXHR, textStatus) -> 
                obj = {}
                obj.errorMessages = [options.url + ' -> [Statut : ' + jqXHR.status + ',' + jqXHR.statusText + ']']
                failure?(obj)
             
        
        ###
        * Convert ajax response to object 
        * @param options
        ###
        toObject: (response) -> 
            retour = response
            try
                retour = JSON.parse response
            catch e 
            
            if _private.isString retour
                if retour == _private.SUCCESS then retour = {typeMessage: _private.SUCCESS, errorMessages: []}
                else if retour == _private.ERROR then retour = {typeMessage: _private.SUCCESS, errorMessages: ['Erreur technique']}
                else retour = {typeMessage: _private.SUCCESS, errorMessages: [retour]}
            else if typeof retour['aaData'] isnt 'undefined'
                retour = {
                    typeMessage: _private.SUCCESS,
                    errorMessages: [],
                    data: retour['aaData']
                }
            else if typeof retour['object'] isnt 'undefined'
                retour = {
                    typeMessage: _private.SUCCESS,
                    errorMessages: [],
                    data: retour['object']
                }
            retour
        
        
        ###====================================================================================
        #                                   methodes ajax
        #===================================================================================###
        ###
        # configure referentiel query
        # @param params
        # @param isDefaultParams
        # @return old params
        # @exception NOT_OBJECT_EXCEPTION, ARGUMENT_EXCEPTION
        ###
        confReferentiel: (conf, isDefaultConf) -> 

            _private.notObjectException conf, "conf must be an object value (util.confReferentiel)."

            expr = (_private.isNotNullOrUndefined isDefaultConf) and _private.isNotBoolean isDefaultConf
            _private.argumentException expr, "isDefaultConf must be a null, undefined or boolean value (util.confReferentiel)."

            _private['paramsReferentiel'] = _private.factoryConfReferentiel conf, _private['defaultParamsReferentiel']

            if isDefaultConf is true then _private['defaultParamsReferentiel'] = _private.clone _private['paramsReferentiel']
            
        
        ###
        # Send referentiel query (see jquery ajax for more information)
        # @param url
        # @param data
        # @param success
        # @param failure
        # @exception BLANK_EXCEPTION, NOT_STRING_EXCEPTION, ARGUMENT_EXCEPTION
        ###
        referentiel: (name, success, faillure) -> 

            response = "";

            _private.blankException name, "name mustn't be blank (util.referentiel)."
            _private.notStringException name, "name must be a string value (util.referentiel)."


            if _private.isNotBlank _private['cacheReferentiel'][name] then response = _private['cacheReferentiel'][name];success?(response)
            else 
                repalceUrl = _private['defaultParamsReferentiel']['repalceUrl']
                url = _private['defaultParamsReferentiel']['url']
                expr = url.indexOf repalceUrl < 0;
                _private.argumentException expr, "repalceUrl isn't present in default url (util.referentiel)."

                _private.confReferentiel {
                    success: (resp) -> if _private.isNotNullOrUndefined resp then response = resp.obj;success?(resp)
                    faillure: faillure
                }

                conf = _private.clone _private['paramsReferentiel']
                conf['url'] = url.replace repalceUrl, name

                _private.query conf

            response
        
        ###
        # factory conf referentiel query
        # @param conf
        # @param defaultConf
        # @private
        # @exception NOT_OBJECT_EXCEPTION, EMPTY_EXCEPTION, NOT_STRING_EXCEPTION, NOT_BOOLEAN_EXCEPTION, ARGUMENT_EXCEPTION
        ###
        factoryConfReferentiel: (conf, defaultConf) -> 

            _private.notObjectException conf, "conf must be an object value (util.factoryConfReferentiel)."
            _private.notObjectException defaultConf, "defaultConf must be an object (util.factoryConfReferentiel)."
            _private.emptyException defaultConf, "defaultConf mustn't be an empty object (util.factoryConfReferentiel)."

            retour = _private.clone defaultConf

            #url
            if _private.isNotNullOrUndefined conf['url']
                _private.notStringException conf['url'], "conf.url must be a string value (util.factoryConfReferentiel)."
                retour['url'] = conf['url']

            #repalceUrl
            if _private.isNotNullOrUndefined conf['repalceUrl']
                _private.notStringException conf['repalceUrl'], "conf.repalceUrl must be a string value (util.factoryConfReferentiel)."
                retour['repalceUrl'] = _private.clone conf['repalceUrl']

            #success
            if _private.isNotUndefined conf['success']
                expr = (_private.isNotNull conf['success']) and _private.isNotFunction conf['success']
                _private.argumentException expr, "conf.success must be a null or a function value (util.factoryParamsAjax)."
                retour['success'] = conf['success']

            #failure
            if _private.isNotUndefined conf['failure']
                expr = (_private.isNotNull conf['failure']) and _private.isNotFunction conf['failure']
                _private.argumentException expr, "conf.failure must be a null or a function value (util.factoryParamsAjax)."
                retour['failure'] = conf['failure']

            #method
            if _private.isNotNullOrUndefined conf['method']
                _private.notStringException conf['method'], "conf.method must be a string value (util.factoryParamsAjax)."
                expr = conf['method'] isnt 'POST' and conf['method'] isnt 'GET'
                _private.argumentException expr, "conf.methode must be equals to 'GET' or 'POST' (util.factoryParamsAjax)."
                retour['method'] = conf['method']

            #async
            if _private.isNotNullOrUndefined conf['async']
                _private.notBooleanException conf['async'], "conf.async must be a boolean value (util.factoryParamsAjax)."
                retour['async'] = conf['async']

            retour
            
        
        ###====================================================================================
        *                                   methodes debug
        *===================================================================================###
        ###
        # enable/disable mode debug
        # @param modeDebug
        # @exception NOT_BOOLEAN_EXCEPTION
        ###
        modeDebug: (isModeDebug) -> 
            _private.notBooleanException isModeDebug, "isModeDebug must be a boolean value (util.modeDebug)"
            _private.isModeDebug = isModeDebug
        
        
        ###
        # write in console debug
        # @param message
        ###
        debug: (message) -> if _private.isModeDebug then console.log "DEBUG #{message}"
        
        
        ###
        # write in console error
        # @param message
        ###
        error: (message) -> console.error "ERROR #{message}"
        
        
        ###====================================================================================
        #                                   methodes date
        #===================================================================================###
        ###
        # Create a new date with format in param
        # @param dateString
        # @param format
        # @return Date
        ###
        newDate: (dateString, format) -> 
            date = null;
            if _private.isNullOrUndefined dateString then date = null
            else if util.isArray regexFormat[format] then date = new Date dateString.replace regexFormat[format][0], regexFormat[format][1]
            else date = new Date dateString
            date;
        
        
        ###
        # Formatted date
        # @param date
        # @param format
        # @return string
        # @exception NOT_STRING_EXCEPTION, ARGUMENT_EXCEPTION
        ###
        formattedDate: (date, format) -> 
            _private.notStringException format, "util.formattedDate => format must be an string value."
            _private.argumentException _private.isValideDate(date), "util.formattedDate => date isn't a date value."
            moment(date).format format
            
        
        ###
        # Date is valide
        # @param date
        # @return boolean
        ###
        isValideDate: (date) -> 
            if (_private.isObject date) and isNaN date.getTime() then true
            else false
        
    }

    _public = {

        UNDEFINED: _private.UNDEFINED,
        NULL: _private.NULL,
        BOOLEAN: _private.BOOLEAN,
        NUMBER: _private.NUMBER,
        STRING: _private.STRING,
        OBJECT: _private.OBJECT,
        ARRAY: _private.ARRAY,
        FUNCTION: _private.FUNCTION,

        FORMAT_DATE_DD_MM_YYYY_1: _private.FORMAT_DATE_DD_MM_YYYY_1,
        FORMAT_DATE_DD_MM_YY_1: _private.FORMAT_DATE_DD_MM_YY_1,
        FORMAT_DATE_DD_MM_YYYY_2: _private.FORMAT_DATE_DD_MM_YYYY_2,
        FORMAT_DATE_DD_MM_YY_2: _private.FORMAT_DATE_DD_MM_YY_2,
        FORMAT_DATE_MM_DD_YYYY_1: _private.FORMAT_DATE_MM_DD_YYYY_1,
        FORMAT_DATE_MM_DD_YY_1: _private.FORMAT_DATE_MM_DD_YY_1,
        FORMAT_DATE_MM_DD_YYYY_2: _private.FORMAT_DATE_MM_DD_YYYY_2,
        FORMAT_DATE_MM_DD_YY_2: _private.FORMAT_DATE_MM_DD_YY_2,

        SUCCESS: _private.SUCCESS,
        ERROR: _private.ERROR,

        ARGUMENT_EXCEPTION: _private.ARGUMENT_EXCEPTION,
        NULL_OR_UNDEFINED_EXCEPTION: _private.NULL_OR_UNDEFINED_EXCEPTION,
        NOT_NULL_OR_UNDEFINED_EXCEPTION: _private.NOT_NULL_OR_UNDEFINED_EXCEPTION,
        NULL_EXCEPTION: _private.NULL_EXCEPTION,
        NOT_NULL_EXCEPTION: _private.NOT_NULL_EXCEPTION,
        UNDEFINED_EXCEPTION: _private.UNDEFINED_EXCEPTION,
        NOT_UNDEFINED_EXCEPTION: _private.NOT_UNDEFINED_EXCEPTION,
        BLANK_EXCEPTION: _private.BLANK_EXCEPTION,
        NOT_BLANK_EXCEPTION: _private.NOT_BLANK_EXCEPTION,
        EMPTY_EXCEPTION: _private.EMPTY_EXCEPTION,
        NOT_EMPTY_EXCEPTION: _private.NOT_EMPTY_EXCEPTION,
        BOOLEAN_EXCEPTION: _private.BOOLEAN_EXCEPTION,
        NOT_BOOLEAN_EXCEPTION: _private.NOT_BOOLEAN_EXCEPTION,
        NUMBER_EXCEPTION: _private.NUMBER_EXCEPTION,
        NOT_NUMBER_EXCEPTION: _private.NOT_NUMBER_EXCEPTION,
        STRING_EXCEPTION: _private.STRING_EXCEPTION,
        NOT_STRING_EXCEPTION: _private.NOT_STRING_EXCEPTION,
        OBJECT_EXCEPTION: _private.OBJECT_EXCEPTION,
        NOT_OBJECT_EXCEPTION: _private.NOT_OBJECT_EXCEPTION,
        ARRAY_EXCEPTION: _private.ARRAY_EXCEPTION,
        NOT_ARRAY_EXCEPTION: _private.NOT_ARRAY_EXCEPTION,
        FUNCTION_EXCEPTION: _private.FUNCTION_EXCEPTION,
        NOT_FUNCTION_EXCEPTION: _private.NOT_FUNCTION_EXCEPTION,

        argumentException: _private.argumentException,
        nullOrUndefinedException: _private.nullOrUndefinedException,
        notNullOrUndefinedException: _private.notNullOrUndefinedException,
        nullException: _private.nullException,
        notNullException: _private.notNullException,
        undefinedException: _private.undefinedException,
        notUndefinedException: _private.notUndefinedException,
        blankException: _private.blankException,
        notBlankException: _private.notBlankException,
        emptyException: _private.emptyException,
        notEmptyException: _private.notEmptyException,
        booleanException: _private.booleanException,
        notBooleanException: _private.notBooleanException,
        numberException: _private.numberException,
        notNumberException: _private.notNumberException,
        stringException: _private.stringException,
        notStringException: _private.notStringException,
        objectException: _private.objectException,
        notObjectException: _private.notObjectException,
        arrayException: _private.arrayException,
        notArrayException: _private.notArrayException,
        functionException: _private.functionException,
        notFunctionException: _private.notFunctionException,

        isNullOrUndefined: _private.isNullOrUndefined,
        isNotNullOrUndefined: _private.isNotNullOrUndefined,
        isBlank: _private.isBlank,
        isNotBlank: _private.isNotBlank,
        isEmpty: _private.isEmpty,
        isNotEmpty: _private.isNotEmpty,
        oneIsEmpty: _private.oneIsEmpty,
        isEquals: _private.isEquals,
        oneIsEquals: _private.oneIsEquals,
        contain: _private.contain,
        noContain: _private.noContain,
        clone: _private.clone,

        isNull: _private.isNull,
        isNotNull: _private.isNotNull,
        isUndefined: _private.isUndefined,
        isNotUndefined: _private.isNotUndefined,
        isBoolean: _private.isBoolean,
        isNotBoolean: _private.isNotBoolean,
        isNumber: _private.isNumber,
        isNotNumber: _private.isNotNumber,
        isString: _private.isString,
        isNotString: _private.isNotString,
        isObject: _private.isObject,
        isNotObject: _private.isNotObject,
        isArray: _private.isArray,
        isNotArray: _private.isNotArray,
        isFunction: _private.isFunction,
        isNotFunction: _private.isNotFunction,
        getType : _private.getType,

        confAjax: _private.confAjax,
        ajax: _private.ajax,

        confReferentiel: _private.confReferentiel,
        referentiel: _private.referentiel,

        modeDebug: _private.modeDebug,
        debug: _private.debug,
        error: _private.error,

        newDate: _private.newDate,
        formattedDate: _private.formattedDate,
        isValideDate: _private.isValideDate

    }

    _public

)()
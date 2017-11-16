var app = angular.module('reitDataApp', []);

app
    .factory('converterService', ReitConverterService)
    .controller('reitDataCtrl', ['$scope', '$window', 'converterService', function($scope, $window, converterService) {
    $scope.reitDatas = $window.reitDatas;
    $scope.sortBy = "";
    $scope.debugMode = true;
  
    $scope.init = function() {
        console.log("angular scope: " + $scope.reitDatas.length);
        converterService.Converts($scope.reitDatas);

        for (var i = 0; i < $scope.reitDatas.length; i++) {
            var tmpGearing = $scope.reitDatas[i].gearing.replace(/[A-Z\$%]+/g, "");
            if (parseFloat(tmpGearing) != NaN) {
                $scope.reitDatas[i].displayGearing = parseFloat(tmpGearing);
            } else {
                $scope.reitDatas[i].displayGearing = 0;
            }
        }
    };
}]);

var appShipping = angular.module('shippingDataApp', []);

appShipping
    .factory('converterService', ReitConverterService)
    .controller('shippingDataCtrl', ['$scope', '$window', 'converterService', function($scope, $window, converterService) {
    $scope.shippingDatas = $window.shippingDatas;
    $scope.sortBy = "";
    $scope.debugMode = true;
  
    $scope.init = function() {
        console.log("angular scope: " + $scope.shippingDatas.length);
        converterService.Converts($scope.shippingDatas);
    };
}]);

var appOther = angular.module('otherDataApp', []);

appOther
    .factory('converterService', ReitConverterService)
    .controller('otherDataCtrl', ['$scope', '$window', 'converterService', function($scope, $window, converterService) {
    $scope.otherDatas = $window.otherDatas;
    $scope.sortBy = "";
    $scope.debugMode = true;
  
    $scope.init = function() {
        console.log("angular scope: " + $scope.otherDatas.length);
        converterService.Converts($scope.otherDatas);
    };
}]);

var appSti = angular.module('stiDataApp', []);

appSti
    .factory('converterService', YieldStockConverterService)
    .controller('stiDataCtrl', ['$scope', '$window', 'converterService', function($scope, $window, converterService) {
    $scope.stiDatas = $window.stiDatas;
    $scope.sortBy = "";
    $scope.debugMode = true;
  
    $scope.init = function() {
        console.log("angular scope: " + $scope.stiDatas.length);
        converterService.Converts($scope.stiDatas);
    };
}]);

var appAviation = angular.module('aviationDataApp', []);

appAviation
    .factory('converterService', YieldStockConverterService)
    .controller('aviationDataCtrl', ['$scope', '$window', 'converterService', function($scope, $window, converterService) {
    $scope.aviationDatas = $window.aviationDatas;
    $scope.sortBy = "";
    $scope.debugMode = true;
  
    $scope.init = function() {
        console.log("angular scope: " + $scope.aviationDatas.length);
        converterService.Converts($scope.aviationDatas);
    };
}]);

var appTransport = angular.module('transportDataApp', []);

appTransport
    .factory('converterService', YieldStockConverterService)
    .controller('transportDataCtrl', ['$scope', '$window', 'converterService', function($scope, $window, converterService) {
    $scope.transportDatas = $window.transportDatas;
    $scope.sortBy = "";
    $scope.debugMode = true;
  
    $scope.init = function() {
        console.log("angular scope: " + $scope.transportDatas.length);
        converterService.Converts($scope.transportDatas);
    };
}]);

var appTelco = angular.module('telcoDataApp', []);

appTelco
    .factory('converterService', YieldStockConverterService)
    .controller('telcoDataCtrl', ['$scope', '$window', 'converterService', function($scope, $window, converterService) {
    $scope.telcoDatas = $window.telcoDatas;
    $scope.sortBy = "";
    $scope.debugMode = true;
  
    $scope.init = function() {
        console.log("angular scope: " + $scope.telcoDatas.length);
        converterService.Converts($scope.telcoDatas);
    };
}]);

var appFinance = angular.module('financeDataApp', []);

appFinance
    .factory('converterService', FinanceConverterService)
    .controller('financeDataCtrl', ['$scope', '$window', 'converterService', function($scope, $window, converterService) {
    $scope.financeDatas = $window.financeDatas;
    $scope.sortBy = "";
    $scope.debugMode = true;
  
    $scope.init = function() {
        console.log("angular scope: " + $scope.financeDatas.length);
        converterService.Converts($scope.financeDatas);
    };
}]);

var appInfra = angular.module('infraDataApp', []);

appInfra
    .factory('converterService', ConverterService)
    .controller('infraDataCtrl', ['$scope', '$window', 'converterService', function($scope, $window, converterService) {
    $scope.infraDatas = $window.infraDatas;
    $scope.sortBy = "";
    $scope.debugMode = true;
  
    $scope.init = function() {
        console.log("angular scope: " + $scope.infraDatas.length);
        converterService.Converts($scope.infraDatas);
    };
}]);

function ConverterService() {
    // service definition
    var service = {};
    
    service.Converts = Converts;
    service.Convert = Convert;
    service.CalculateYield = CalculateYield;
    
    return service;

    function Converts(reitDatas) {
        for (var i = 0; i < reitDatas.length; i++) {
            Convert(reitDatas[i]);
        }
    }
    
    function Convert(reitData) {
        if (parseFloat(reitData.prevClosed) != NaN) {
            reitData.displayPrevClosed = parseFloat(reitData.prevClosed);
        }
        
        if (parseFloat(reitData.dpu) != NaN) {
            reitData.displayDpu = parseFloat(reitData.dpu);
        }

        reitData.displayYield = CalculateYield(reitData);
    }
    
    function CalculateYield(reitData) {
        var ttlDpu = 0;
        var prevClosed = 0;
        
        if (parseFloat(reitData.ttlDpu) != NaN) {
            ttlDpu = parseFloat(reitData.ttlDpu);
        }
            
        if (parseFloat(reitData.prevClosed) != NaN) {
            prevClosed = parseFloat(reitData.prevClosed);
        }
           
        if (ttlDpu > 0) {
            if (prevClosed > 0) {
                return (ttlDpu / prevClosed);
            } 
        }
        
        var tmpYield = reitData.yield.replace(/[A-Z\$%]+/g, "");
        if (parseFloat(tmpYield) != NaN) {
            return parseFloat(tmpYield);
        } else {
            return 0;
        }
    }
}

function ReitConverterService() {
    // service definition
    var service = {};
    var baseService = new ConverterService();
    
    service.Converts = Converts;
    service.Convert = Convert;
    service.CalculateYield = CalculateYield;
    
    return service;

    function Converts(reitDatas) {
        for (var i = 0; i < reitDatas.length; i++) {
            Convert(reitDatas[i]);
        }
    }
    
    function Convert(reitData) {
        baseService.Convert(reitData);
        
        var tmpNav = reitData.nav.replace(/[A-Z\$%]+/g, "");
        if (parseFloat(tmpNav) != NaN) {
            reitData.displayNav = parseFloat(tmpNav);
        } else {
            reitData.displayNav = 0;
        }
    }
    
    function CalculateYield(reitData) {
        return baseService.CalculateYield(reitData);
    }
}

function YieldStockConverterService() {
    // service definition
    var service = {};
    var baseService = new ConverterService();
    
    service.Converts = Converts;
    service.Convert = Convert;
    service.CalculateYield = CalculateYield;
    service.CalculatePe = CalculatePe;
    
    return service;

    function Converts(reitDatas) {
        for (var i = 0; i < reitDatas.length; i++) {
            Convert(reitDatas[i]);
        }
    }
    
    function Convert(reitData) {
        baseService.Convert(reitData);

        if (parseFloat(reitData.epsCts) != NaN) {
            reitData.displayEpsCts = parseFloat(reitData.epsCts);
        }
        
        CalculatePe(reitData);        
    }
    
    function CalculatePe(reitData) {
        if (reitData.displayPrevClosed != 0 && reitData.displayEpsCts != 0) {
            reitData.displayPe = reitData.displayPrevClosed * 100 / reitData.displayEpsCts;
        } else {
            if (parseFloat(reitData.pe) != NaN) {
                reitData.displayPe = parseFloat(reitData.pe);
            }
        }
    }
    
    function CalculateYield(reitData) {
        return baseService.CalculateYield(reitData);
    }
}
   
function FinanceConverterService() {
    // service definition
    var service = {};
    var baseService = new YieldStockConverterService();
    
    service.Converts = Converts;
    service.Convert = Convert;
    service.CalculateYield = CalculateYield;
    service.CalculatePe = CalculatePe;
    
    return service;

    function Converts(reitDatas) {
        for (var i = 0; i < reitDatas.length; i++) {
            Convert(reitDatas[i]);
        }
    }
    
    function Convert(reitData) {
        baseService.Convert(reitData);
        
        var tmp = reitData.nbv.replace(/[A-Z\$%]+/g, "");
        if (parseFloat(tmp) != NaN) {
            reitData.displayNbv = parseFloat(tmp);
        }

        tmp = reitData.nbvBefore.replace(/[A-Z\$%]+/g, "");
        if (parseFloat(tmp) != NaN) {
            reitData.displayNbvBefore = parseFloat(tmp);
        }

        tmp = reitData.epsCtsBefore.replace(/[A-Z\$%]+/g, "");
        if (parseFloat(tmp) != NaN) {
            reitData.displayEpsCtsBefore = parseFloat(tmp);
        }
        
        CalculatePe(reitData);
    }
    
    function CalculatePe(reitData) {
        if (reitData.displayPrevClosed != 0 && reitData.displayEpsCts != 0) {
            reitData.displayPe = reitData.displayPrevClosed / reitData.displayEpsCts;
        } else {
            if (parseFloat(reitData.pe) != NaN) {
                reitData.displayPe = parseFloat(reitData.pe);
            }
        }
        
        if (reitData.displayPrevClosed != 0 && reitData.displayEpsCtsBefore != 0) {
            reitData.displayPeBefore = reitData.displayPrevClosed / reitData.displayEpsCtsBefore;
        } else {
            if (parseFloat(reitData.peBefore) != NaN) {
                reitData.displayPeBefore = parseFloat(reitData.peBefore);
            }
        }
    }
    
    function CalculateYield(reitData) {
        return baseService.CalculateYield(reitData);
    }
}

angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById("appReit"), ['reitDataApp']);
    angular.bootstrap(document.getElementById("appOther"), ['otherDataApp']);
    angular.bootstrap(document.getElementById("appShipping"), ['shippingDataApp']);
    angular.bootstrap(document.getElementById("appSti"), ['stiDataApp']);
    angular.bootstrap(document.getElementById("appAviation"), ['aviationDataApp']);
    angular.bootstrap(document.getElementById("appTransport"), ['transportDataApp']);
    angular.bootstrap(document.getElementById("appTelco"), ['telcoDataApp']);
    angular.bootstrap(document.getElementById("appFinance"), ['financeDataApp']);
    angular.bootstrap(document.getElementById("appInfra"), ['infraDataApp']);
});
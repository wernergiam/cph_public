var app = angular.module('reitAnnouncementApp', []);

app
    .factory('pagerService', PagerService)
    .factory('focusService', FocusService)
    .controller('reitAnnouncementDataCtrl', ['$scope', '$window', '$http', 'pagerService', function($scope, $window, $http, PagerService) {
    $scope.AnnouncementByTimePeriods = $window.AnnouncementByTimePeriods;
    $scope.AnnouncementByIssuers = $window.AnnouncementByIssuers;
    $scope.AnnouncementBySecuritys = $window.AnnouncementBySecuritys;
    $scope.filterby = { "company": false, "security": true, "companyFilter": "", "securityFilter": "" };
    $scope.period = AnnouncementByTimePeriods[0];
    $scope.error = "";
    $scope.pager = {};
    $scope.debugMode = false;
    $scope.issuer = null;
    $scope.security = null;
  
    $scope.init = function() {
        if ($scope.debugMode) {
            console.log("angular scope time period: " + $scope.AnnouncementByTimePeriods.length);
            console.log("angular scope issuer: " + $scope.AnnouncementByIssuers.length);
            console.log("angular scope security: " + $scope.AnnouncementBySecuritys.length);
            console.log(PagerService);
        }
        $scope.pager = PagerService.GetPager(0, 1, 20);
        if ($scope.debugMode) {
            console.log($scope.pager);
        }
    };
    
    $scope.setPage = function(page) {
        if ($scope.debugMode) {
            console.log("page: " + page);
        }
        if (page < 1 || page > $scope.pager.totalPages) {
            return;
        }
 
        // get pager object from service
        $scope.pager = PagerService.GetPager($scope.pager.totalItems, page, 20);
    }
    
    $scope.fetchData = function() {
        $scope.error = "Loading ...";
        if ($scope.debugMode) {
            console.log("period: " + JSON.stringify($scope.period));
            console.log("issuer: " + JSON.stringify($scope.issuer));
            console.log("security: " + JSON.stringify($scope.security));
            console.log("filterby: " + JSON.stringify($scope.filterby));
        }
        var proxy_url = "http://www.reitdata.com/reitdata/proxy.php?csurl=";
        var url = "http://www.sgx.com/proxy/SgxDominoHttpProxy";
        var dominoHost = "http://infofeed.sgx.com/Apps?A=COW_CorpAnnouncement_Content&B=";
        
        dominoHost = dominoHost + $scope.period.View;
        if ($scope.filterby.security) {
            if ($scope.security != null) {
                dominoHost = dominoHost + "Security";
                dominoHost = dominoHost + "&R_C=N_A~N_A~N_A~" + $scope.security.SecurityName;
            } else {
                dominoHost = dominoHost + "&R_C=";
            }
        } else {
            if ($scope.issuer != null) {
                dominoHost = dominoHost + "&R_C=" + $scope.issuer.IssuerName;
            } else {
                dominoHost = dominoHost + "&R_C=";
            }
        }
                
        if ($scope.pager.currentPage > 1) {
            dominoHost = dominoHost + "&S_T=" + ((($scope.pager.currentPage - 1) * 20) + 1);
        } 
        dominoHost = dominoHost + "&C_T=20";
        var fire_url = proxy_url + url + "&dominoHost=" + encodeURIComponent(dominoHost);
        if ($scope.debugMode) {
            console.log("fire_url: " + fire_url);
        }
        
        $http({
            method: "GET",
            url: fire_url
        }).then(
            function successCallBack(response) {
                if ($scope.debugMode) {
                    console.log(response);
                    console.log('json: ' + response);
                }
                $scope.error = "";
                if (response.data.items === "No Document Found") {
                    $scope.announcementDatas = [];
                    $scope.pager = PagerService.GetPager(0, $scope.pager.currentPage, 20);
                    $scope.error = "No data found!";
                } else { 
                    $scope.announcementDatas = response.data;
                    if ($scope.announcementDatas != null) {
                        if ($scope.announcementDatas.items != null) {
                            if ($scope.announcementDatas.items.length > 0) {
                                var siblings = $scope.announcementDatas.items[0].Siblings;
                                $scope.pager = PagerService.GetPager(siblings, $scope.pager.currentPage, 20);
                                if ($scope.debugMode) {
                                    console.log($scope.pager);
                                }
                            }
                        }
                    }
                }
            },
            function errorCallBack(response) {
                if ($scope.debugMode) {
                    console.log(response);
                }
                $scope.error = JSON.stringify(response);
            }
        );
        //$scope.announcementDatas = {"SHARES":123, "items":[{"key":"S7O3JOCYRBY5CD12&H=70478f0b8dc73ca43fb998405cc97af37b77a50140f825868d96e5e6d9e14fdd","Date":"21 Nov 2016","Time":"09:18:37 AM","IssuerName":"FANTASIA HOLDINGS GROUP CO., LIMITED","SecurityName":"MULTIPLE","GroupCode":"ANNC","CategoryCode":"ANNC18","CategoryName":"General Announcement","AnnTitle":"General Announcement::FURTHER PURCHASE OF SENIOR NOTES","BroadcastDateTime":"11/21/2016 9:18:37 AM","Siblings":"14"},{"key":"GB7HKVLES5BAWNUA&H=7367b4b0b6aa0c41fc0138aa4589e5955649e4b1379c3f1841934462168b1d28","Date":"21 Nov 2016","Time":"08:45:30 AM","IssuerName":"SIA ENGINEERING COMPANY LIMITED","SecurityName":"SIA ENGINEERING CO LTD","GroupCode":"ANNC","CategoryCode":"ANNC13","CategoryName":"Share Buy Back-On Market","AnnTitle":"Share Buy Back - Daily Share Buy-Back Notice::Share Buy Back - Daily Share Buy-Back Notice","BroadcastDateTime":"11/21/2016 8:45:30 AM","Siblings":"14"},{"key":"N5GA7VEBNVT3CEF8&H=88bfe2c0e1cf859ec8b889e0383bcc33ffda1032ec046ebdf8ec3e99470288e4","Date":"21 Nov 2016","Time":"08:30:57 AM","IssuerName":"AUSGROUP LIMITED","SecurityName":"MULTIPLE","GroupCode":"ANNC","CategoryCode":"ANNC18","CategoryName":"General Announcement","AnnTitle":"General Announcement::Consent Solicitation Exercise   Entry into Second Supplemental Trust Deed","BroadcastDateTime":"11/21/2016 8:30:57 AM","Siblings":"14"},{"key":"JN43ABSL2PSNN9KN&H=ff2c16fcaade617407c572f4dcc3532bffe21c1285714e517712bbac51012985","Date":"21 Nov 2016","Time":"08:22:11 AM","IssuerName":"AUSGROUP LIMITED","SecurityName":"MULTIPLE","GroupCode":"ANNC","CategoryCode":"ANNC28","CategoryName":"Waiver","AnnTitle":"Waiver::Approval for an Extension of Time to announce 1Q2017 results","BroadcastDateTime":"11/21/2016 8:22:11 AM","Siblings":"14"},{"key":"6W224W1938CK8MQ2&H=760bfd1a6cb6d030bedbefafc01b2be25b43b5f0fdc16bebd348da7a21cf7aea","Date":"21 Nov 2016","Time":"08:15:39 AM","IssuerName":"ISR CAPITAL LIMITED","SecurityName":"ISR CAPITAL LIMITED","GroupCode":"ANNC","CategoryCode":"ANNC18","CategoryName":"General Announcement","AnnTitle":"General Announcement::PRESS RELEASE:SGX-LISTED ISR CAPITAL RE-DESIGNATES MINING EXPERT MR CHEN TONG AS EXECUTIVE CHAIRMAN","BroadcastDateTime":"11/21/2016 8:15:39 AM","Siblings":"14"},{"key":"DOVADSWLY2SKK4QA&H=a5ed36d41bfbf82a58721effd73e1c354cfc9f5592a86042948b171cc78935b0","Date":"21 Nov 2016","Time":"08:14:55 AM","IssuerName":"ISR CAPITAL LIMITED","SecurityName":"ISR CAPITAL LIMITED","GroupCode":"ANNC","CategoryCode":"ANNC03","CategoryName":"Announcement of Appointment","AnnTitle":"Change - Announcement of Appointment::APPOINTMENT OF EXECUTIVE CHAIRMAN","BroadcastDateTime":"11/21/2016 8:14:55 AM","Siblings":"14"},{"key":"2Y6Z8AMJW1UGY0IH&H=7994f35add6168f24733505ac22b7c70cc50a3c8bc59f86054b2df0e3c912e1c","Date":"21 Nov 2016","Time":"07:47:09 AM","IssuerName":"TAT HONG HOLDINGS LTD","SecurityName":"TAT HONG HOLDINGS LTD","GroupCode":"ANNC","CategoryCode":"ANNC14","CategoryName":"Disclosure of Interest/ Changes in Interest","AnnTitle":"Disclosure of Interest/ Changes in Interest of Substantial Shareholder(s)/ Unitholder(s)::Cessation as a Substantial Shareholder","BroadcastDateTime":"11/21/2016 7:47:09 AM","Siblings":"14"},{"key":"PEUX6B07WWDIDO2S&H=208024e5860c66e49c43cf059abc7c9ddc375aea126f63b4b28df597c55d1875","Date":"21 Nov 2016","Time":"07:46:43 AM","IssuerName":"TAT HONG HOLDINGS LTD","SecurityName":"TAT HONG HOLDINGS LTD","GroupCode":"ANNC","CategoryCode":"ANNC14","CategoryName":"Disclosure of Interest/ Changes in Interest","AnnTitle":"Disclosure of Interest/ Changes in Interest of Substantial Shareholder(s)/ Unitholder(s)::Cessation as a Substantial Shareholder","BroadcastDateTime":"11/21/2016 7:46:43 AM","Siblings":"14"},{"key":"TMROGMB7X5CHJ4FA&H=9cbb9da1a8929d0d9b8059d215e6d3c85efcf85b004405d8e2b41b4c2f3b0cf0","Date":"21 Nov 2016","Time":"07:46:39 AM","IssuerName":"ASIATRAVEL.COM HOLDINGS LTD","SecurityName":"ASIATRAVEL.COM HOLDINGS LTD","GroupCode":"ANNC","CategoryCode":"ANNC18","CategoryName":"General Announcement","AnnTitle":"General Announcement::Request for Suspension - Sponsor Statement","BroadcastDateTime":"11/21/2016 7:46:39 AM","Siblings":"14"},{"key":"73ILR36O4I49XYM7&H=70b5086e7008d6f4095436fe183f386dcbc8f66568466be8693e17bc95b6afd6","Date":"21 Nov 2016","Time":"07:45:48 AM","IssuerName":"ASIATRAVEL.COM HOLDINGS LTD","SecurityName":"ASIATRAVEL.COM HOLDINGS LTD","GroupCode":"TRAD","CategoryCode":"TRAD05","CategoryName":"Request for Suspension","AnnTitle":"Request for Suspension::Mandatory","BroadcastDateTime":"11/21/2016 7:45:48 AM","Siblings":"14"},{"key":"35N07B6ITIN10LBT&H=8a734900c7da6f354c4b96608fd57c698843bcfd2a4b981e08104d8d3b156cd6","Date":"21 Nov 2016","Time":"07:35:17 AM","IssuerName":"SBI OFFSHORE LIMITED","SecurityName":"SBI OFFSHORE LIMITED","GroupCode":"ANNC","CategoryCode":"ANNC18","CategoryName":"General Announcement","AnnTitle":"General Announcement::Update on the NPT transactions - Appointment of UniLegal LLC as the legal advisor","BroadcastDateTime":"11/21/2016 7:35:17 AM","Siblings":"14"},{"key":"5P9IR09ZL52D3CGG&H=fa585097134323396c5cd560d0ee9e62f63e6b86b628505633770c005595bb38","Date":"21 Nov 2016","Time":"07:22:08 AM","IssuerName":"ISDN HOLDINGS LIMITED","SecurityName":"MULTIPLE","GroupCode":"ANNC","CategoryCode":"ANNC18","CategoryName":"General Announcement","AnnTitle":"General Announcement::UPDATE ON THE PROPOSED DUAL LISTING IN HONG KONG","BroadcastDateTime":"11/21/2016 7:22:08 AM","Siblings":"14"},{"key":"1JSAMCKHZ61IBFFL&H=837be0f0999c4532d02fd2d61e7c604900075dbbc7d00816f5aef2bda76648d6","Date":"21 Nov 2016","Time":"07:17:38 AM","IssuerName":"CAPITALAND LIMITED","SecurityName":"CAPITALAND LIMITED","GroupCode":"ANNC","CategoryCode":"ANNC18","CategoryName":"General Announcement","AnnTitle":"General Announcement::Presentation Slides - \"CapitaLand Analysts/Media Trip 2016\"","BroadcastDateTime":"11/21/2016 7:17:38 AM","Siblings":"14"},{"key":"BYULTQWE8NF5HUWU&H=35a84d3f22fd3c8307f60c3b4869bada65fe4fb23d7c043eba2425af84d86d8f","Date":"21 Nov 2016","Time":"07:02:41 AM","IssuerName":"MIE HOLDINGS CORPORATION","SecurityName":"MULTIPLE","GroupCode":"PLST","CategoryCode":"PLST01","CategoryName":"Change of Terms","AnnTitle":"Debt - Change of Terms::RESULTS OF CONSENT SOLICITATION FOR ITS 6.875% SENIOR NOTES DUE 2018 AND 7.50% SENIOR NOTES DUE 2019","BroadcastDateTime":"11/21/2016 7:02:41 AM","Siblings":"14"}]};
    };
    
    $scope.filterCompanyData = function(filterCompany) {
        if ($scope.debugMode) {
            console.log("filterCompany: " + JSON.stringify(filterCompany));
        }
        return function(AnnouncementByIssuer) { 
            return AnnouncementByIssuer.IssuerName.toLowerCase().indexOf(filterCompany.toLowerCase()) === 0; 
        };
    };
    
    $scope.filterSecurityData = function(filterSecurity) {
        if ($scope.debugMode) {
            console.log("filterSecurity: " + JSON.stringify(filterSecurity));
        }
        return function(AnnouncementBySecurity) { 
            return AnnouncementBySecurity.SecurityName.toLowerCase().indexOf(filterSecurity.toLowerCase()) === 0; 
        };
    };
}])
    .directive('ngEnter', function() {
        return function(scope, element, attrs) {
                element.bind("keydown keypress", function(event) {
                    if (event.which === 13) {
                        scope.$apply(function() {
                            scope.$eval(attrs.ngEnter, {'event': event});
                        });
    
                        event.preventDefault();
                    }
                });
            };
        });

function PagerService() {
    // service definition
    var service = {};
    
    service.GetPager = GetPager;
    
    return service;
    
    // service implementation
    function GetPager(totalItems, currentPage, pageSize) {
        // default to first page
        currentPage = currentPage || 1;
    
        // default page size is 10
        pageSize = pageSize || 10;
    
        // calculate total pages
        var totalPages = Math.ceil(totalItems / pageSize);
    
        var startPage, endPage;
        if (totalPages <= 10) {
            // less than 10 total pages so show all
            startPage = 1;
            endPage = totalPages;
        } else {
            // more than 10 total pages so calculate start and end pages
            if (currentPage <= 6) {
                startPage = 1;
                endPage = 10;
            } else if (currentPage + 4 >= totalPages) {
                startPage = totalPages - 9;
                endPage = totalPages;
            } else {
                startPage = currentPage - 5;
                endPage = currentPage + 4;
            }
        }
    
        // calculate start and end item indexes
        var startIndex = (currentPage - 1) * pageSize;
        var endIndex = Math.min(startIndex + pageSize - 1, totalItems - 1);
    
        // create an array of pages to ng-repeat in the pager control
        var pages = _.range(startPage, endPage + 1);
    
        // return object with all pager properties required by the view
        return {
            totalItems: totalItems,
            currentPage: currentPage,
            pageSize: pageSize,
            totalPages: totalPages,
            startPage: startPage,
            endPage: endPage,
            startIndex: startIndex,
            endIndex: endIndex,
            pages: pages
        };
    }
}

function FocusService() {
    // service definition
    var service = {};
    
    service.GetFocus = GetFocus;
    
    return service;

    function GetFocus($timeout, $window) {
        return function(id) {
            // timeout makes sure that it is invoked after any other event has been triggered.
            // e.g. click events that need to run before the focus or
            // inputs elements that are in a disabled state but are enabled when those events
            // are triggered.
            $timeout(function() {
                var element = $window.document.getElementById(id);
                if (element) {
                    element.focus();
                }
            });
        };
    }
}

//$(document).ready(function() {
//    $.getScript('https://cdnjs.cloudflare.com/ajax/libs/select2/3.4.8/select2.min.js',function() {

//        $('#period').select2({
//            
//        });
//                
//        $('#issuer').select2({
//                 
//        });
//                        
//        $('#security').select2({
//                    
//        });
    
//    });//script
//});

import "@hotwired/turbo-rails"
import "controllers"

import 'debugging/hotwire'
import 'custom/turbo_stream_actions'

/*
    This might feel hacky, I would like to make this more pragmatic.
    This hides the save predictions button if turbo is available since live saving 
    should be the default 
*/
if (!isSavingData() && !hasSlowInternet()) {
    ['turbo:render', 'turbo:load'].forEach(eventType => {
        addEventListener(eventType, (event) => {
            document.getElementById('sticky_bottom')?.classList.add('hidden')
        })
    });
}

function isSavingData() {
    return navigator.connection?.saveData
}

function hasSlowInternet() {
    return navigator.connection?.effectiveType === "slow-2g" ||
        navigator.connection?.effectiveType === "2g" ||
        navigator.connection?.effectiveType === "3g"
}

*** Variables ***
${XSS_SCRIPT_ALERT}    <script>alert("hello, this is an XSS test !");</script>
${XSS_IMG_ONEERROR}    <img src=x onerror=alert('XSS')>
${XSS_SVG_ONLOAD}    <svg onload=alert('XSS SVG ATTACK !')>
${XSS_JAVASCRIPT_URL}    javascript:alert('XSS ATTACK !')
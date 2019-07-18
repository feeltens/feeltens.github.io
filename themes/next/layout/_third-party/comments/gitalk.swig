{% if page.comments && theme.gitalk.enable %}
  <link rel="stylesheet" href="https://unpkg.com/gitalk/dist/gitalk.css">
  <script src="https://unpkg.com/gitalk/dist/gitalk.min.js"></script>
  <script src="{{ site.baseurl }}/js/md5.min.js"></script>
   <script type="text/javascript">
        var gitalk = new Gitalk({
          clientID: 'b1ea7fce22d3683d8110',
          clientSecret: 'a4e04d34706709c25a54211e9947e72a8613681d',
          repo: 'hexo-gitalk',
          owner: 'feeltens',
          admin: ['feeltens'],
          id: md5(location.pathname),
          distractionFreeMode: 'true'
        })
        gitalk.render('gitalk-container')
       </script>
{% endif %}
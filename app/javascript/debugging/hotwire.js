if (window.location.host === 'localhost:3000') {
   const eventGroups = {
      '#3B82F6': [ // Blue: Navigation/Visits
         'turbo:click', 'turbo:before-visit', 'turbo:visit', 'turbo:load',
         'turbo:reload', 'turbo:before-prefetch'
      ],
      '#10B981': [ // Green: Rendering/Morphing
         'turbo:before-render', 'turbo:render', 'turbo:before-cache',
         'turbo:before-stream-render', 'turbo:morph', 'turbo:before-morph-element',
         'turbo:morph-attribute'
      ],
      '#8B5CF6': [ // Purple: Frames
         'turbo:before-frame-render', 'turbo:frame-render', 'turbo:frame-load',
         'turbo:before-frame-fetch'
      ],
      '#F59E0B': [ // Amber: HTTP/Forms
         'turbo:submit-start', 'turbo:submit-end', 'turbo:before-fetch-request',
         'turbo:before-fetch-response', 'turbo:fetch-slow'
      ],
      '#EF4444': [ // Red: Errors
         'turbo:frame-missing', 'turbo:fetch-request-error', 'turbo:morph-error'
      ]
   };

   Object.entries(eventGroups).forEach(([color, events]) => {
      events.forEach(eventName => {
         document.addEventListener(eventName, (event) => {
            console.log(
               `%c 🚀 Turbo %c ${event.type} `,
               `background: #333; color: #fff; border-radius: 3px 0 0 3px; padding: 2px 4px;`,
               `background: ${color}; color: #fff; border-radius: 0 3px 3px 0; padding: 2px 4px; font-weight: bold;`,
               {
                  time: new Date().toLocaleTimeString(),
                  detail: event.detail,
                  target: event.target
               }
            );
         });
      });
   });
}
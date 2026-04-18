import { Turbo } from "@hotwired/turbo-rails"
import Swal from "sweetalert2";

Turbo.StreamActions.toast = function () {
   const content = this.getAttribute("content");
   const type = this.getAttribute("type") || "success";

   // Define the Boltaspá palette hex codes directly
   const colorMap = {
      success: "#059669", // emerald-600
      error: "#e11d48",   // rose-600
      info: "#2563eb",    // blue-600
      warning: "#d97706"  // amber-600
   };

   const activeColor = colorMap[type] || colorMap.success;

   const Toast = Swal.mixin({
      toast: true,
      position: "top-end",
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,

      // FORCING THE COLORS HERE
      iconColor: "#ffffff",
      background: activeColor, // This kills the white background
      color: "#ffffff",        // This kills the black text

      customClass: {
         popup: `rounded-2xl shadow-2xl border-0 flex items-center`,
         title: "font-bold text-sm px-2 m-0 bg-transparent text-white",
         timerProgressBar: "bg-white/40",
      }
   });

   Toast.fire({
      icon: 'warning',
      title: content,
   });
}
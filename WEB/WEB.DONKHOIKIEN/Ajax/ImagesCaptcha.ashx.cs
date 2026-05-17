using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Linq;
using System.Text;
using System.Web;

namespace WEB.DONKHOIKIEN.Ajax
{
    /// <summary>
    /// Summary description for ImagesCaptcha
    /// </summary>
    public class ImagesCaptcha : IHttpHandler
    {


        public bool IsReusable { get { return true; } }


        public void ProcessRequest(HttpContext context)
        {
            try
            {
                context.Response.ContentType = "image";
                string str = context.Request.QueryString["imagetext"] + "";


                //Kiểm tra đã có chuỗi xác thực thì draw chuỗi xác thực
                if (context.Cache[str] != null)
                {
                    string[] fonts = { "Arial Black", "Lucida Sans Unicode", "Comic Sans MS" };

                    using (Bitmap bmp = new Bitmap(130, 40))
                    {
                        using (Graphics g = Graphics.FromImage(bmp))
                        {

                            // Tạo nền cho ảnh dạng sóng
                            HatchBrush brush = new HatchBrush(HatchStyle.Percent05, Color.Black, Color.White);
                            g.FillRegion(brush, g.Clip);

                            Random rand = new Random();

                            // Tạo font với tên font ngẫu nhiên chọn từ mảng fonts
                            Font font = new Font(fonts[rand.Next(fonts.Length)], 17, FontStyle.Strikeout | FontStyle.Italic);

                            // Lấy kích thước của kí tự
                            SizeF size = g.MeasureString(str, font);

                            // Vẽ kí tự đó ra ảnh tại vị trí tăng dần theo i, vị trí top ngẫu nhiên

                            g.DrawString(Convert.ToString(context.Cache[str]), font,

                            Brushes.Black, 0 * size.Width + 3, rand.Next(2, 5));
                            font.Dispose();

                            // Lưu ảnh vào thư mục captcha với tên ảnh dựa theo IP//khong can thaet trong truonng hop nay
                            //string path = "~/Images/CaptCha/" + Guid.NewGuid().ToString() + ".gif";

                            bmp.Save(context.Response.OutputStream, ImageFormat.Gif);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
                //context.Response.Write("{ \"ret\": \"-1\", \"msg\": \"" + ex.Message + "\" }");
            }
        }
    }
}
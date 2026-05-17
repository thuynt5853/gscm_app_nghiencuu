using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DAL.DKK;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.DonKK.DanhMuc;
using BL.DonKK;
using Module.Common;
using System.Globalization;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class VBTongDat : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        public Decimal UserID = 0;

        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadDrop();
                    if (!string.IsNullOrEmpty(Request["status"] + ""))
                        dropTrangThai.SelectedValue = Request["status"] + "";
                    LoadData();
                }
                
                
            }
            else Response.Redirect("/Trangchu.aspx");
        }
        void LoadDrop()
        {
            dropTrangThai.Items.Clear();
            dropTrangThai.Items.Add(new ListItem("----Tất cả----", ENUM_ISREAD.TATCA.ToString()));
            dropTrangThai.Items.Add(new ListItem("Văn bản, thông báo mới của Tòa án", ENUM_ISREAD.CHUADOC.ToString()));
            dropTrangThai.Items.Add(new ListItem("Văn bản, thông báo đã đọc", ENUM_ISREAD.DADOC.ToString()));          
        }

        void LoadData()
        {
            lbthongbao.Text = "";
            string hoTen = txtHoten.Text;
            string tucachtt = ddlTuCachToTung.SelectedValue;
            string vuviec = txtVuViec.Text.Trim();
            int trangthai = Convert.ToInt16(dropTrangThai.SelectedValue);
            int toa_an_id = (string.IsNullOrEmpty(hddToaAnID.Value)) ? 0 : Convert.ToInt32(hddToaAnID.Value);
            if (String.IsNullOrEmpty(txtToaAn.Text.Trim()))
            {
                toa_an_id = 0;
                hddToaAnID.Value = "";
            }
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DataTable tbl = null;
            DonKK_VBTongDat_BL objBL = new DonKK_VBTongDat_BL();
            tbl = objBL.GetAllPaging(UserID, vuviec, toa_an_id, tucachtt, hoTen, trangthai, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                string StrVuViec = "";
                string temp = "";
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                foreach(DataRow row in tbl.Rows)
                {
                    StrVuViec = String.IsNullOrEmpty(row["TenVuViec"] + "") ? "" : "<li><b>Vụ việc:</b>" + row["TenVuViec"].ToString() + "</li>";
                    temp = String.IsNullOrEmpty(row["TenToaAn"] + "") ? "" : "<li><b>Tòa án thụ lý:</b>" + row["TenToaAn"].ToString() + "</li>";
                    if (StrVuViec.Length > 0)
                    {
                        if (temp.Length > 0)
                            StrVuViec += temp;
                    }
                    else
                        StrVuViec = temp;
                    if (StrVuViec.Length > 0)
                        StrVuViec = "<ul>" + StrVuViec + "</ul>";
                    row["TenVuViec"] = StrVuViec;

                    String ngay_gui =null;
                    if(!String.IsNullOrEmpty(row["NgayGui"]+""))
                        ngay_gui = Convert.ToDateTime(row["NgayGui"]+"").ToString("dd/MM/yyyy hh:mm tt", cul);
                    //-----------------------------
                    if (Convert.ToInt16(row["IsRead"] + "") > 0)
                    {
                        temp = "- Trạng thái: " + "<b>" + row["TrangThaiDoc"] + "</b>" ;
                        temp += "<br/>- Ngày tống đạt: ";
                        //temp += "<b>" + string.Format("{0:dd/MM/yyyy}", row["NgayGui"] + "</b>");
                        temp += "<b>" + ngay_gui + "</b>" ;
                    }
                    else temp = row["TrangThaiDoc"] + "";
                    row["TrangThaiDoc"] = temp;
                }               

                    #region "Xác định số lượng trang"
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> văn bản, thông báo trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pnDS.Visible = true;
            }
            else
            {
                pnDS.Visible = false;
                lbthongbao.Text = "Không có văn bản thông báo của Tòa án!";
            }
        }
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            hddPageIndex.Value = "1";
            LoadData();
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command_name = e.CommandName;
            string command_arg = e.CommandArgument.ToString();
            switch (command_name)
            {

                case "dowload":
                    //DowloadFile(Convert.ToDecimal(command_arg));
                    GetBase64File(Convert.ToDecimal(command_arg));
                    break;
                case "view":
                    
                    Response.Redirect("/Personnal/ChiTietVB.aspx?vID=" + command_arg);
                    //DowloadFile(Convert.ToDecimal(command_arg));
                    break;
            }
        }

        public void GetBase64File(decimal VanBanID)
        {
            try
            {
                DKKContextContainer dt = new DKKContextContainer();
                DONKK_DON_VBTONGDAT oND = dt.DONKK_DON_VBTONGDAT.Where(x => x.ID == VanBanID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    Cls_Comon.CallFunctionJS(this,this.GetType(), "GetBase64File('" + Convert.ToBase64String(oND.NOIDUNGFILE) + "','"+ oND.TENFILE + "')");
                }
                else
                {
                    lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể xem được!";
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể xem được!";
            }
        }    

        void DowloadFile(Decimal VanBanID)
        {
            try
            {
                DONKK_DON_VBTONGDAT oND = dt.DONKK_DON_VBTONGDAT.Where(x => x.ID == VanBanID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    if (oND.NOIDUNGFILE != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.LOAIFILE + "';", true);
                    }
                    else
                    {
                        lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                    }
                }
                //---------------------
                if ((String.IsNullOrEmpty(oND.ISREAD +"")) || (oND.ISREAD ==0))
                {
                    oND.ISREAD = 1;
                    oND.NGAYDOC = DateTime.Now;
                    dt.SaveChanges();
                    GhiLog(oND);
                    ShowTB_TiepNhanVB();
                    LoadData();
                }
            }
            catch (Exception ex)
            {
                // lttThongBaoTop.Text = lbthongbao.Text = ex.Message;
            }
        }
        void GhiLog(DONKK_DON_VBTONGDAT oND)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            decimal UserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String Detail_Action = CurrUserName + " - Nhận văn bản, thông báo mới từ Tòa án.<br/>";
            String KeyLog = ENUM_HD_NGUOIDUNG_DKK.NHANVB;

            //-----------------------------
            Detail_Action += "- Vụ việc:<br/>";
            Detail_Action += "+ Lĩnh vực: ";
            switch (oND.MALOAIVUVIEC)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    Detail_Action += "Dân sự";
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    Detail_Action += "Hành chính";
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    Detail_Action += "Hôn nhân & Gia đình";
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    Detail_Action += "Kinh doanh & Thương mại";
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    Detail_Action += "Lao động";
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    Detail_Action += "Phá sản";
                    break;
            }
            Detail_Action += "<br/>";
            Detail_Action += "+ Số vụ việc:" + oND.VUVIECID + "<br/>";
            Detail_Action += "+ Tên vụ việc:" + oND.TENVANBAN;
            //--------------
            DONKK_USER_HISTORY_BL objBL = new DONKK_USER_HISTORY_BL();
            objBL.WriteLog(UserID, KeyLog, Detail_Action);
        }

        void ShowTB_TiepNhanVB()
        {
            string temp = "";
            string ma_tiepnhanvb = "tiepnhanvbtongdat";
            DM_TRANGTINH_BL obj = new DM_TRANGTINH_BL();
            String NoiDung = obj.GetNoiDungByMaTrang(ma_tiepnhanvb);
            if (!String.IsNullOrEmpty(NoiDung))
                temp = NoiDung;
            temp = String.Format(temp, Session[ENUM_SESSION.SESSION_USERTEN] + "", DateTime.Now.ToString("dd/MM/yyyy hh:mm tt", cul));
            string TenNguoiDung =  Session[ENUM_SESSION.SESSION_USERTEN] + "";
            temp = String.Format(temp, TenNguoiDung, DateTime.Now.ToString("dd/MM/yyyy hh:mm tt", cul));

            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", temp);
            //lbthongbao.Text = temp;
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ImageButton imgFile = (ImageButton)e.Item.FindControl("imgFile");
                DataRowView rv = (DataRowView)e.Item.DataItem;
                if (!string.IsNullOrEmpty(rv["LoaiFile"] + ""))
                {
                    string loaifile = rv["LoaiFile"].ToString().ToLower().Replace(".", "");
                    switch (loaifile)
                    {
                        case "pdf":
                            imgFile.ImageUrl = "/UI/img/pdf.png";
                            break;
                        case "doc":
                            imgFile.ImageUrl = "/UI/img/word.png";
                            break;
                        case "docx":
                            imgFile.ImageUrl = "/UI/img/word.png";
                            break;
                        case "xls":
                            imgFile.ImageUrl = "/UI/img/excel.jpeg";
                            break;
                        case "xlsx":
                            imgFile.ImageUrl = "/UI/img/excel.jpeg";
                            break;
                        case "rar":
                            imgFile.ImageUrl = "/UI/img/rar.png";
                            break;
                        case "zip":
                            imgFile.ImageUrl = "/UI/img/zip.jpeg";
                            break;
                        default:
                            imgFile.ImageUrl = "/UI/img/attachfile.png";
                            break;
                    }
                    imgFile.Width = 27;
                    imgFile.Height = 32;
                }
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void dropTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
    }
}
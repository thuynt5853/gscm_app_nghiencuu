using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using BL.DonKK;
using Module.Common;
using System.Globalization;
namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class DsDon : System.Web.UI.Page
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
                    LoadData();
                }
                dropTrangThai.Attributes.Add("onchange", "change_control()");
                txtToaAn.Attributes.Add("onblur", "Load_data_theodk();");
            }
            else Response.Redirect("/Trangchu.aspx");
        }
        void LoadDrop()
        {
            dropTrangThai.Items.Clear();
            dropTrangThai.Items.Add(new ListItem("---Tất cả----", 11.ToString()));
            dropTrangThai.Items.Add(new ListItem("Đơn chưa gửi", 10.ToString()));
            dropTrangThai.Items.Add(new ListItem("Đơn đã gửi và chờ giải quyết", 0.ToString()));            
            dropTrangThai.Items.Add(new ListItem("Đơn chờ bổ sung theo yêu cầu của Tòa án", ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon.ToString()));
            dropTrangThai.Items.Add(new ListItem("Đơn bị Tòa án trả lại", ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon.ToString()));
            dropTrangThai.Items.Add(new ListItem("Đơn đã thụ lý", ENUM_ADS_BIENPHAPGQ.ADS_ThuLy.ToString()));

            if (!string.IsNullOrEmpty(Request["status"] + ""))
                dropTrangThai.SelectedValue = Request["status"].ToString();
        }
        void LoadData()
        {
            lbthongbao.Text = "";
            int Loai = Convert.ToInt16(dropTrangThai.SelectedValue);
            int trangthai = Convert.ToInt16(dropTrangThai.SelectedValue);
            string vuviec = txtVuViec.Text.Trim();
            string duong_su = txtDuongSu.Text.Trim();
            decimal toa_an_id = (string.IsNullOrEmpty(hddToaAnID.Value))?0:Convert.ToDecimal(hddToaAnID.Value);
            if (String.IsNullOrEmpty(txtToaAn.Text.Trim()))
            {
                toa_an_id = 0;
                hddToaAnID.Value = "";
            }

            int page_size = Convert.ToInt32(dropPageSize.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            DataTable tbl = null;
            DONKK_DON_BL objBL = new DONKK_DON_BL();
            tbl = objBL.Search(UserID, trangthai, toa_an_id, vuviec, duong_su, dFrom, dTo, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
        
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadData();
        }
        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
        
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command_name = e.CommandName;
            string command_arg = e.CommandArgument.ToString();
            switch (command_name)
            {
                case "Xoa":
                    Xoa(Convert.ToDecimal(command_arg));
                    hddPageIndex.Value = "1";
                    LoadData();
                    break;
                case "ThemTL":
                    Response.Redirect("UpdateTLDon.aspx?vID=" + command_arg);
                    break;
            }
        }
        void Xoa(Decimal curr_id)
        {
            try {
                List<DONKK_DON_TAILIEU> lstTL = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == curr_id).ToList();
                if (lstTL != null && lstTL.Count>0)
                {
                    foreach(DONKK_DON_TAILIEU item in lstTL)
                        dt.DONKK_DON_TAILIEU.Remove(item);
                }
            } catch(Exception ex) { }

            try {
                List<DONKK_DON_DUONGSU> lstDS = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == curr_id).ToList();
                if (lstDS != null && lstDS.Count > 0)
                {
                    foreach (DONKK_DON_DUONGSU item in lstDS)
                        dt.DONKK_DON_DUONGSU.Remove(item);
                }
            }
            catch (Exception ex){ }
            try
            {
                DONKK_DON obj = dt.DONKK_DON.Where(x => x.ID == curr_id).Single<DONKK_DON>();
                if (obj != null)
                    dt.DONKK_DON.Remove(obj);
            }
            catch (Exception ex){ }
            dt.SaveChanges();
        }
       
        int type_bosung = Convert.ToInt32(ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon);
        int type_chuyentrongnganh = Convert.ToInt32(ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh);

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                HiddenField hddDonKKID = (HiddenField)e.Item.FindControl("hddDonKKID");
                Decimal DonKKID = Convert.ToDecimal(hddDonKKID.Value);

                Literal lttEdit = (Literal)e.Item.FindControl("lttEdit");
                Literal lttTooltip = (Literal)e.Item.FindControl("lttTooltip");
                
                ImageButton imgDel = (ImageButton)e.Item.FindControl("imgDel");
                
                //---------------------------------------
                ImageButton imgBSTaiLieu = (ImageButton)e.Item.FindControl("imgBSTaiLieu");
                Literal lttToolTipBSTaiLieu = (Literal)e.Item.FindControl("lttToolTipBSTaiLieu");
                lttToolTipBSTaiLieu.Text = "<span class='tooltiptext tooltip-bottom'>Thêm tài liệu</span>";

                Literal lttTooltipXoa = (Literal)e.Item.FindControl("lttTooltipXoa");
                lttTooltipXoa.Text = "<span class='tooltiptext tooltip-bottom'>Xóa</span>";
                
                //---------------------------------------
                HiddenField hddTrangthai = (HiddenField)e.Item.FindControl("hddTrangthai");
                int TrangThai = Convert.ToInt32(hddTrangthai.Value);
                string link = "", img = "", tooltip = "";
                string yeucau_don = "";
                imgDel.Visible = false;
                yeucau_don = "<span class='trangthaihs'>" + rowView["TrangThaiHoSo"] + "</span>";
                switch (TrangThai)
                {                    
                    case 10:
                        //----cho phep sua don---------   
                        link = "GuiDonKien.aspx?dID=" + DonKKID;
                        tooltip = "Sửa";
                        img = "<img src='/UI/img/edit.png' alt='Sửa'/>";
                        imgDel.Visible = true;
                        break;                   
                    case 1:
                        //chuyen don trong nganh
                        yeucau_don += (String.IsNullOrEmpty(rowView["YeuCau"] + "")) ? "" : (" tới <b>" + rowView["YeuCau"] + "</b>");
                        break;
                    case 2:
                        //chuyen don ngoai nganh 
                        yeucau_don += (String.IsNullOrEmpty(rowView["YeuCau"] + "")) ? "" : (" tới <b>" + rowView["YeuCau"] + "</b>");
                        break;
                    case 3:
                        //tra lai don
                        yeucau_don += (String.IsNullOrEmpty(rowView["YeuCau"]+""))? "":("<br/><span class='title_yeucau'>Lý do:</span><span class='str_yeucau'>" + rowView["YeuCau"] + "</span>");
                         imgDel.Visible = imgBSTaiLieu.Visible = lttToolTipBSTaiLieu.Visible =  false;
                        break;
                    case 4:
                        //yeu cau bo sung
                        yeucau_don += (String.IsNullOrEmpty(rowView["YeuCau"] + "")) ? "" : ("<br/><span class='title_yeucau'>Yêu cầu:</span><span class='str_yeucau'>" + rowView["YeuCau"] + "</span>");
                        lttToolTipBSTaiLieu.Text = "<span class='tooltiptext tooltip-bottom'>Bổ sung tài liệu</span>";

                        //----cho phep sua don---------                        
                        lttEdit.Visible = true;
                        link = "GuiDonKien.aspx?dID=" + DonKKID;
                        tooltip = "Bổ sung thông tin";
                        img = "<img src='/UI/img/edit.png' alt='Sửa'/>";
                        break;
                }
                //----TrangThai = luu tam + Yeu cau bo sung thi cho phep sua
                // cac loai khac chi cho xem--------
                if (TrangThai != 10  && TrangThai != 4)
                {
                    link = "ChiTietDon.aspx?ID=" + DonKKID;
                    tooltip = "Xem chi tiết";
                    img = "<img src='/UI/img/view.png' alt='xem chi tiết'/>";                    
                }
               
                //--------------------------
                if (!imgDel.Visible)
                    lttTooltipXoa.Text = "";

                if (!imgBSTaiLieu.Visible)
                    lttToolTipBSTaiLieu.Text = "";

                if (!lttEdit.Visible)
                    lttTooltip.Text = "";
                else
                    lttTooltip.Text = "<span class='tooltiptext tooltip-bottom'>" + tooltip + "</span>";
                //--------------------------
                Literal lttTrangThai = (Literal)e.Item.FindControl("lttTrangThai");
                lttTrangThai.Text = yeucau_don;

                Literal lttCountVB = (Literal)e.Item.FindControl("lttCountVB");
                lttCountVB.Text = "<a href='" + link + "'>" + rowView["CountVB"] + "</a>";
                
                lttEdit.Text = "<a href='" + link + "'>" + img + "</a>";

                Literal lttTenVuViec = (Literal)e.Item.FindControl("lttTenVuViec");
                lttTenVuViec.Text = "<a href='" + link + "'>" + rowView["TenVuViec"] + "" + "</a>";
            }
        }
    }
}
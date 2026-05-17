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

namespace WEB.DONKHOIKIEN.Personnal.UC
{
    public partial class DsHoSo : System.Web.UI.UserControl
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
                    int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
                    if (MucDichSD != 2)
                        LoadData();
                    else
                        pn.Visible = false;
                }
            }
            else Response.Redirect("/Trangchu.aspx");
        }
        void LoadData()
        {
            int soluong = Convert.ToInt16(hddSoLuong.Value);
             //-------------------------
            DataTable tbl = null;
            DONKK_DON_BL objBL = new DONKK_DON_BL();
            tbl = objBL.GetTopDonDangGiaoDichByUser(UserID, soluong);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
                int count = tbl.Rows.Count;
                if (count == soluong)
                    lttViewMore.Text = "<a href='/Personnal/Dsdon.aspx' class='viewmore'>Xem thêm</a>";
            }
            else
            {
                rpt.Visible = false;
            }
        }
     
        string temp = "";
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command_name = e.CommandName;
            string command_arg = e.CommandArgument.ToString();
            switch (command_name)
            {
                case "Sua":
                    String[] arr = command_arg.Split(';');

                    string MaLoaiVuViec = arr[1].ToString();
                    //switch (MaLoaiVuViec)
                    //{
                    //    case ENUM_LOAIAN.AN_DANSU:
                    //        temp = "GuiDonKien.aspx";
                    //        break;
                    //    case ENUM_LOAIAN.AN_HANHCHINH:
                    //        temp = "GuiDonKien_HC.aspx";
                    //        break;
                    //    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    //        temp = "GuiDonKien_HN.aspx";
                    //        break;
                    //    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    //        temp = "GuiDonKien_KD.aspx";
                    //        break;
                    //    case ENUM_LOAIAN.AN_LAODONG:
                    //        temp = "GuiDonKien_LD.aspx";
                    //        break;
                    //    case ENUM_LOAIAN.AN_PHASAN:
                    //        temp = "GuiDonKien_PS.aspx";
                    //        break;
                    //}
                    Response.Redirect("ChiTietDon.aspx?ID=" + arr[0]);
                    break;
                case "Xoa":
                    Xoa(Convert.ToDecimal(command_arg));
                    break;
            }
        }
        void Xoa(Decimal curr_id)
        {
            DONKK_DON obj = dt.DONKK_DON.Where(x => x.ID == curr_id).Single<DONKK_DON>();
            string MaLoaiVuViec = obj.MALOAIVUAN;
            Decimal VuAnID = Convert.ToDecimal(obj.VUANID);
            switch (MaLoaiVuViec)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    break;
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                HiddenField hddDonKKID = (HiddenField)e.Item.FindControl("hddDonKKID");
                Decimal DonKKID = Convert.ToDecimal(hddDonKKID.Value);

                Literal lttEdit = (Literal)e.Item.FindControl("lttEdit");

                //---------------------------------------
                ImageButton imgBSTaiLieu = (ImageButton)e.Item.FindControl("imgBSTaiLieu");
                Literal lttToolTipBSTaiLieu = (Literal)e.Item.FindControl("lttToolTipBSTaiLieu");
                lttToolTipBSTaiLieu.Text = "<span class='tooltiptext tooltip-bottom'>Thêm tài liệu</span>";

                //---------------------------------------
                HiddenField hddTrangthai = (HiddenField)e.Item.FindControl("hddTrangthai");
                int TrangThai = Convert.ToInt32(hddTrangthai.Value);
                string link = "", img = "", tooltip = "";
                string yeucau_don = "";
                yeucau_don = "<span class='trangthaihs'>" + rowView["TrangThaiHoSo"] + "</span>";
                switch (TrangThai)
                {
                    case 10:
                        //----cho phep sua don---------   
                        link = "GuiDonKien.aspx?dID=" + DonKKID;
                        tooltip = "Sửa";
                        img = "<img src='/UI/img/edit.png' alt='Sửa'/>";
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
                        yeucau_don += (String.IsNullOrEmpty(rowView["YeuCau"] + "")) ? "" : ("<br/><span class='title_yeucau'>Lý do:</span><span class='str_yeucau'>" + rowView["YeuCau"] + "</span>");
                        imgBSTaiLieu.Visible = lttToolTipBSTaiLieu.Visible = false;
                        break;
                    case 4:
                        //yeu cau bo sung
                        yeucau_don += (String.IsNullOrEmpty(rowView["YeuCau"] + "")) ? "" : ("<br/><span class='title_yeucau'>Yêu cầu:</span><span class='str_yeucau'>" + rowView["YeuCau"] + "</span>");
                        lttToolTipBSTaiLieu.Text = "<span class='tooltiptext tooltip-bottom'>Bổ sung tài liệu</span>";

                        //----cho phep sua don---------                        
                        lttEdit.Visible = true;
                        link = "GuiDonKien.aspx?dID=" + DonKKID;
                        tooltip = "Sửa";
                        img = "<img src='/UI/img/edit.png' alt='Sửa'/>";
                        break;
                }
                //----TrangThai = luu tam + Yeu cau bo sung thi cho phep sua
                // cac loai khac chi cho xem--------
                if (TrangThai != 10 && TrangThai != 4)
                {
                    link = "ChiTietDon.aspx?ID=" + DonKKID;
                    tooltip = "Xem chi tiết";
                    img = "<img src='/UI/img/view.png' alt='xem chi tiết'/>";
                }
                //--------------------------
                if (!imgBSTaiLieu.Visible)
                    lttToolTipBSTaiLieu.Text = "";

                Literal lttTooltip = (Literal)e.Item.FindControl("lttTooltip");
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
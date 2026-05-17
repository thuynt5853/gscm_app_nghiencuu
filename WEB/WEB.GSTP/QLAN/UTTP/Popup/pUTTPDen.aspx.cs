using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.UTTP.Popup
{
    public partial class pUTTPDen : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session[ENUM_SESSION.SESSION_DONVIID] == null)
                {
                    Response.Redirect("/Trangchu.aspx");
                    Response.End();
                }
                decimal donviId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                var donvi = dt.DM_TOAAN.FirstOrDefault(s => s.ID == donviId);
                if (donvi.LOAITOA == "CAPHUYEN")
                {
                    Response.Redirect("/Trangchu.aspx");
                    Response.End();
                }
                LoadDataQuocGiaUT();
                LoadDataCanBo();
                //LoadGrid();
                //kiểm tra là thêm mới hay sửa
                string strUTTPDenID = Request.QueryString["UTTPDenID"];
                decimal UTTPDenID = Convert.ToDecimal(strUTTPDenID);
                if (UTTPDenID==0)
                {
                    //thêm mới
                }
                else
                {
                    loadedit(UTTPDenID);
                }
            }
        }
        private void LoadDataQuocGiaUT()
        {
            var dataQuocGiaUT = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);

            ddllQuocGiaUT.DataSource = dataQuocGiaUT;
            ddllQuocGiaUT.DataTextField = "TEN";
            ddllQuocGiaUT.DataValueField = "ID";
            ddllQuocGiaUT.DataBind();
            ddllQuocGiaUT.Items.Insert(0, new ListItem("--Danh mục--", "0"));
        }

        private void LoadDataCanBo()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddllNguoiThucHienUT.DataSource = oCBDT;
            ddllNguoiThucHienUT.DataTextField = "HOTEN";
            ddllNguoiThucHienUT.DataValueField = "ID";
            ddllNguoiThucHienUT.DataBind();
            ddllNguoiThucHienUT.Items.Insert(0, new ListItem("--Danh mục--", "0"));
        }

        private bool valid()
        {
            if (string.IsNullOrEmpty(txttCoQuanUTTP.Text))
            {
                lbthongbao.Text = "Vui lòng nhập cơ quan UTTP!";
                return false;
            }
            if (ddllQuocGiaUT.SelectedValue == "0")
            {
                lbthongbao.Text = "Vui lòng nhập quốc gia UT!";
                return false;
            }
            if (string.IsNullOrEmpty(txttVanBanUT.Text))
            {
                lbthongbao.Text = "Vui lòng nhập văn bản UT!";
                return false;
            }
            if (string.IsNullOrEmpty(txttNgayNhanUTTP.Text))
            {
                lbthongbao.Text = "Vui lòng nhập ngày nhận UT!";
                return false;
            }
            //txttNgayNhanUTTP
            return true;
        }
        private void Resetcontrol()
        {
            txttCoQuanUTTP.Text = "";
            ddllQuocGiaUT.SelectedIndex = 0;
            txttVanBanUT.Text = "";
            txttNoiDungUT.Text = "";
            ddllKetQuaThucHienUTTP.SelectedIndex = 0;
            txttNgayCoKetQuaThuHienUTTP.Text = "";
            ddllNguoiThucHienUT.SelectedIndex = 0;
            txttNgayNhanUTTP.Text = "";
            txttGhiChu.Text = "";
            hddid.Value = "";
        }
        protected void lbLuu_Click(object sender, EventArgs e)
        {
            if (valid())
            {
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    UYTHACTUPHAPDEN obj = new UYTHACTUPHAPDEN();
                    obj.COQUANUT = txttCoQuanUTTP.Text;
                    obj.QUOCGIAUT = Convert.ToDecimal(ddllQuocGiaUT.SelectedValue);
                    obj.VANBANUT = txttVanBanUT.Text;
                    obj.NOIDUNGUT = txttNoiDungUT.Text;
                    obj.KETQUAUT = Convert.ToDecimal(ddllKetQuaThucHienUTTP.SelectedValue);
                    obj.NGAYCOKETQUAUT = string.IsNullOrEmpty(txttNgayCoKetQuaThuHienUTTP.Text) ? (DateTime?)null : DateTime.Parse(txttNgayCoKetQuaThuHienUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGUOITHUCHIENUT = Convert.ToDecimal(ddllNguoiThucHienUT.SelectedValue);
                    obj.GHICHU = txttGhiChu.Text;
                    obj.NGAYNHANUTTP = string.IsNullOrEmpty(txttNgayNhanUTTP.Text) ? (DateTime?)null : DateTime.Parse(txttNgayNhanUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    obj.NGAYTAO = DateTime.Now;
                    obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.UYTHACTUPHAPDENs.Add(obj);
                    dt.SaveChanges();
                    lbthongbao.Text = "Thêm mới thành công!";
                    Resetcontrol();
                }
                else
                { //sua
                  //lấy ra thông tin theo cái id vần sửa
                    decimal _id = Convert.ToDecimal(hddid.Value);
                    var obj = dt.UYTHACTUPHAPDENs.Where(x => x.ID == _id).FirstOrDefault();
                    if (obj == null) return;

                    obj.COQUANUT = txttCoQuanUTTP.Text;
                    obj.QUOCGIAUT = Convert.ToDecimal(ddllQuocGiaUT.SelectedValue);
                    obj.VANBANUT = txttVanBanUT.Text;
                    obj.NOIDUNGUT = txttNoiDungUT.Text;
                    obj.KETQUAUT = Convert.ToDecimal(ddllKetQuaThucHienUTTP.SelectedValue);
                    obj.NGAYCOKETQUAUT = string.IsNullOrEmpty(txttNgayCoKetQuaThuHienUTTP.Text) ? (DateTime?)null : DateTime.Parse(txttNgayCoKetQuaThuHienUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGUOITHUCHIENUT = Convert.ToDecimal(ddllNguoiThucHienUT.SelectedValue);
                    obj.GHICHU = txttGhiChu.Text;
                    obj.NGAYNHANUTTP = string.IsNullOrEmpty(txttNgayNhanUTTP.Text) ? (DateTime?)null : DateTime.Parse(txttNgayNhanUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    obj.NGAYSUA = DateTime.Now;
                    obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.SaveChanges();
                    hddid.Value = _id + "";
                    lbthongbao.Text = "Lưu thành công!";



                }
                //pnTimKiem.Visible = true;
                //pnThemUTTPDen.Visible = false;

                //dgList.CurrentPageIndex = 0;
                //LoadGrid();
                
            }
        }
        //lbLuuAndQuayLai_Click
        protected void lbLuuAndQuayLai_Click(object sender, EventArgs e)
        {
            if (valid())
            {
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    UYTHACTUPHAPDEN obj = new UYTHACTUPHAPDEN();
                    obj.COQUANUT = txttCoQuanUTTP.Text;
                    obj.QUOCGIAUT = Convert.ToDecimal(ddllQuocGiaUT.SelectedValue);
                    obj.VANBANUT = txttVanBanUT.Text;
                    obj.NOIDUNGUT = txttNoiDungUT.Text;
                    obj.KETQUAUT = Convert.ToDecimal(ddllKetQuaThucHienUTTP.SelectedValue);
                    obj.NGAYCOKETQUAUT = string.IsNullOrEmpty(txttNgayCoKetQuaThuHienUTTP.Text) ? (DateTime?)null : DateTime.Parse(txttNgayCoKetQuaThuHienUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGUOITHUCHIENUT = Convert.ToDecimal(ddllNguoiThucHienUT.SelectedValue);
                    obj.GHICHU = txttGhiChu.Text;
                    obj.NGAYNHANUTTP = string.IsNullOrEmpty(txttNgayNhanUTTP.Text) ? (DateTime?)null : DateTime.Parse(txttNgayNhanUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    obj.NGAYTAO = DateTime.Now;
                    obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.UYTHACTUPHAPDENs.Add(obj);
                    dt.SaveChanges();
                    lbthongbao.Text = "Thêm mới thành công!";

                }
                else
                { //sua
                  //lấy ra thông tin theo cái id vần sửa
                    decimal _id = Convert.ToDecimal(hddid.Value);
                    var obj = dt.UYTHACTUPHAPDENs.Where(x => x.ID == _id).FirstOrDefault();
                    if (obj == null) return;

                    obj.COQUANUT = txttCoQuanUTTP.Text;
                    obj.QUOCGIAUT = Convert.ToDecimal(ddllQuocGiaUT.SelectedValue);
                    obj.VANBANUT = txttVanBanUT.Text;
                    obj.NOIDUNGUT = txttNoiDungUT.Text;
                    obj.KETQUAUT = Convert.ToDecimal(ddllKetQuaThucHienUTTP.SelectedValue);
                    obj.NGAYCOKETQUAUT = string.IsNullOrEmpty(txttNgayCoKetQuaThuHienUTTP.Text) ? (DateTime?)null : DateTime.Parse(txttNgayCoKetQuaThuHienUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGUOITHUCHIENUT = Convert.ToDecimal(ddllNguoiThucHienUT.SelectedValue);
                    obj.GHICHU = txttGhiChu.Text;
                    obj.NGAYNHANUTTP = string.IsNullOrEmpty(txttNgayNhanUTTP.Text) ? (DateTime?)null : DateTime.Parse(txttNgayNhanUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    obj.NGAYSUA = DateTime.Now;
                    obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.SaveChanges();
                    hddid.Value = _id + "";
                    lbthongbao.Text = "Lưu thành công!";



                }
                //pnTimKiem.Visible = true;
                //pnThemUTTPDen.Visible = false;

                //dgList.CurrentPageIndex = 0;
                //LoadGrid();
                //Resetcontrol();

                //load grid
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
            }
        }
        protected void lbQuayLai_Click(object sender, EventArgs e)
        {
            //pnTimKiem.Visible = true;
            //pnThemUTTPDen.Visible = false;
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }
        public void loadedit(decimal ID)
        {
            UYTHACTUPHAPDEN oT = dt.UYTHACTUPHAPDENs.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            hddid.Value = ID + "";
            txttCoQuanUTTP.Text = oT.COQUANUT;
            ddllQuocGiaUT.SelectedValue = oT.QUOCGIAUT.Value.ToString();
            txttVanBanUT.Text = oT.VANBANUT;
            txttNoiDungUT.Text = oT.NOIDUNGUT;
            ddllKetQuaThucHienUTTP.SelectedValue = oT.KETQUAUT.HasValue ? oT.KETQUAUT.Value.ToString() : "0";
            txttNgayCoKetQuaThuHienUTTP.Text = oT.NGAYCOKETQUAUT.HasValue? oT.NGAYCOKETQUAUT.Value.ToString("dd/MM/yyyy"):"";
            ddllNguoiThucHienUT.SelectedValue = oT.NGUOITHUCHIENUT.HasValue ? oT.NGUOITHUCHIENUT.Value.ToString() : "0";
            txttNgayNhanUTTP.Text = oT.NGAYNHANUTTP.HasValue? oT.NGAYNHANUTTP.Value.ToString("dd/MM/yyyy"):"";
            txttGhiChu.Text = oT.GHICHU;
        }
    }
}
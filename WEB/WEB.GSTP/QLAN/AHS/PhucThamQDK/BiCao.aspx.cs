using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.AHS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.PhucThamQDK
{
    public partial class BiCao : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0;
        public Decimal VuAnSTID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            VuAnID = (string.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            if (!IsPostBack)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdUpdateBottom, oPer.CAPNHAT);
                if (VuAnID > 0)
                {
                    AHS_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
                    VuAnSTID = _chuyenNhanBl.getDonIdOld(VuAnID);
                    LoadGrid();

                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lstMsgT.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdUpdateBottom, false);
                        return;
                    }
                }

            }
        }

        public void LoadGrid()
        {
            //VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            // AHS_SOTHAM_BANAN_BL objBL = new AHS_SOTHAM_BANAN_BL();
            //DataTable tbl = objBL.GetAllBiCaoKetAnST(VuAnID);
            AHS_KCKNQDK_PHUCTHAM_BL objBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable tbl = objBL.GetAllByVuAnIDTDC(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows.Count);
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;

                foreach (DataRow row in tbl.Rows)
                {
                    if (Convert.ToInt16(row["IsPhucTham"] + "") > 0)
                        hddBiCanPhucTham.Value += row["BiCaoID"].ToString() + ",";
                }
            }
            else
                rpt.Visible = false;
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            Decimal bicanid = 0;
            Boolean isnew = true;
            string curr_user = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            AHS_KCKNQDK_PHUCTHAM_BICANBICAO obj = null;
            string BiCanPhucTham_Cu = "," + hddBiCanPhucTham.Value;
            string temp = ",";
            foreach (RepeaterItem item in rpt.Items)
            {
                isnew = true;
                temp = "";
                HiddenField hdd = (HiddenField)item.FindControl("hdd");
                bicanid = Convert.ToDecimal(hdd.Value);
                //AHS_BICANBICAO biCanBiCao = dt.AHS_BICANBICAO.Where(x=>x.ID==bicanid).FirstOrDefault();
                CheckBox chkChange = (CheckBox)item.FindControl("chkChange");
                if (chkChange.Checked)
                {
                    temp = "," + bicanid + ",";
                    if (BiCanPhucTham_Cu.Contains(temp))
                        BiCanPhucTham_Cu = BiCanPhucTham_Cu.Replace(temp, ",");
                    //----------------------------------------
                    try
                    {
                        obj = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_BICANBICAO>($"VUANID = {VuAnID} AND BICANID = {bicanid}").FirstOrDefault();
                        if (obj != null)
                            isnew = false;
                        else
                            obj = new AHS_KCKNQDK_PHUCTHAM_BICANBICAO();
                    }
                    catch (Exception ex) { obj = new AHS_KCKNQDK_PHUCTHAM_BICANBICAO(); }
                    obj.BICANID = bicanid;
                    obj.VUANID = VuAnID;

                    if (isnew)
                    {
                        obj.NGUOITAO = curr_user;
                        obj.NGAYTAO = DateTime.Now;
                        DataExtensions.Insert(obj);
                    }
                    else
                    {
                        DataExtensions.Update(obj);
                    }
                }
            }

            if (BiCanPhucTham_Cu != ",")
            {
                String[] arr = BiCanPhucTham_Cu.Split(',');
                foreach (string item in arr)
                {
                    if (!string.IsNullOrEmpty(item + ""))
                    {
                        bicanid = Convert.ToDecimal(item);
                        obj = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_BICANBICAO>($"VUANID = {VuAnID} AND BICANID = {bicanid}").FirstOrDefault();
                        DataExtensions.Delete(obj);
                    }
                }
                dt.SaveChanges();
            }
            lstMsgT.Text = "Cập nhật dữ liệu thành công!";
        }
    }
}
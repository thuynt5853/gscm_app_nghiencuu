using BL.GSTP;
using DAL.GSTP;
using Microsoft.Reporting.WebForms;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace WEB.GSTP.QLAN.GDTTT.In
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                    LoadReport();
            }
        }
        void LoadReport()
        {
            string strMaCT = Session["GDTTT_MABM"] + "";
            switch (strMaCT)
            {
                case "NOIBO_TOTRINH01"://Trình thụ lý mới
                    idTitle.Text = "In phiếu trình";
                    DTGDTTT objds = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objds = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoTotrinh rpt = new rptNoiBoTotrinh();
                    rpt.DataSource = objds;
                    rptView.OpenReport(rpt);
                    break;
                case "NOIBO_TOTRINH02"://Trình đơn trùng
                    idTitle.Text = "In phiếu trình";
                    DTGDTTT objdstdt = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objdstdt = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoTotrinhDonTrung rptTDT = new rptNoiBoTotrinhDonTrung();
                    rptTDT.DataSource = objdstdt;
                    rptView.OpenReport(rptTDT);
                    break;
                case "NOIBO_PHIEUCHUYEN":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objpc = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objpc = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoPhieuchuyen rptpc = new rptNoiBoPhieuchuyen();
                    rptpc.DataSource = objpc;
                    rptView.OpenReport(rptpc);
                    break;
                case "NOIBO_PHIEUCHUYEN_TOICAO":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objpc_tc = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objpc_tc = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoPhieuchuyen_Toicao rptpc_tc = new rptNoiBoPhieuchuyen_Toicao();
                    rptpc_tc.DataSource = objpc_tc;
                    rptView.OpenReport(rptpc_tc);
                    break;
                case "NOIBO_PHIEUCHUYEN_TOICAO_TLL":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objpc_tc_tll = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objpc_tc_tll = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoPhieuchuyen_Toicao_TLL rptpc_tc_tll = new rptNoiBoPhieuchuyen_Toicao_TLL();
                    rptpc_tc_tll.DataSource = objpc_tc_tll;
                    rptView.OpenReport(rptpc_tc_tll);
                    break;
                case "NOIBO_TOTRINHDS":
                    idTitle.Text = "Danh sách";
                    DTGDTTT objTTds = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTTds = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoDanhsach rptNBDS = new rptNoiBoDanhsach();
                    rptNBDS.DataSource = objTTds;
                    rptView.OpenReport(rptNBDS);
                    break;
                case "NOIBO_TOTRINHDSTRUNG":
                    idTitle.Text = "Danh sách";
                    DTGDTTT objTTdstrung = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTTdstrung = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoDSTrung rptNBDSTrung = new rptNoiBoDSTrung();
                    rptNBDSTrung.DataSource = objTTdstrung;
                    rptView.OpenReport(rptNBDSTrung);
                    break;

                case "NOIBO_TBCHUYEN":
                    idTitle.Text = "In thông báo chuyển";
                    DTGDTTT objtbpc = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objtbpc = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoThongBaoChuyen rpttbpc = new rptNoiBoThongBaoChuyen();
                    rpttbpc.DataSource = objtbpc;
                    rptView.OpenReport(rpttbpc);
                    break;
                case "NOIBO_TBCHUYENTRUNG":
                    idTitle.Text = "In thông báo chuyển";
                    DTGDTTT objtbpctr = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objtbpctr = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoPhieuchuyenTrung rpttbpctr = new rptNoiBoPhieuchuyenTrung();
                    rpttbpctr.DataSource = objtbpctr;
                    rptView.OpenReport(rpttbpctr);
                    break;
                case "NOIBO_TOTRINHTPGQ":
                    idTitle.Text = "Danh sách phân công thẩm phán";
                    DTGDTTT objTTdstp = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTTdstp = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoDSPCTP rptNBDSTP = new rptNoiBoDSPCTP();
                    rptNBDSTP.DataSource = objTTdstp;
                    rptView.OpenReport(rptNBDSTP);
                    break;
                case "NOIBO_TRALAIDON":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBTLD = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBTLD = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoTralaidon rptNBTLD = new rptNoiBoTralaidon();
                    rptNBTLD.DataSource = objTBTLD;
                    rptView.OpenReport(rptNBTLD);
                    break;
                case "NOIBO_THONGBAOTG":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBTG = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBTG = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoThongBaoTG rptNBTBTG = new rptNoiBoThongBaoTG();
                    rptNBTBTG.DataSource = objTBTG;
                    DataTable vYCBSTG = objTBTG.DT_NOIBO_THONGBAO;
                    if (vYCBSTG.Rows.Count > 0)
                        rptNBTBTG.DisplayName = "Phiếu chuyển_" + Cls_Comon.ChuyenTVKhongDau(vYCBSTG.Rows[0]["NGUOIGUI"].ToString()).Replace("_", " ");
                    rptView.OpenReport(rptNBTBTG);
                    break;
                case "NOIBO_GXN":
                    idTitle.Text = "Giấy xác nhận";
                    DTGDTTT objTBds = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBds = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoGXN rptNBGXN = new rptNoiBoGXN();
                    rptNBGXN.DataSource = objTBds;
                    rptView.OpenReport(rptNBGXN);
                    break;
                case "NOIBO_THONGBAOLD":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBld = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBld = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoThongBaoLD rptNBTBLD = new rptNoiBoThongBaoLD();
                    rptNBTBLD.DataSource = objTBld;
                    rptView.OpenReport(rptNBTBLD);
                    break;
                case "NOIBO_THONGBAOCOQUAN":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBCQ = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBCQ = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoThongBaoCoQuan rptNBTBCQ = new rptNoiBoThongBaoCoQuan();
                    rptNBTBCQ.DataSource = objTBCQ;
                    rptView.OpenReport(rptNBTBCQ);
                    break;
                case "NOIBO_THONGBAOCOQUAN81":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBCQ81 = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBCQ81 = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptThongbaoCV81 rptNBTBCQ81 = new rptThongbaoCV81();
                    rptNBTBCQ81.DataSource = objTBCQ81;
                    rptView.OpenReport(rptNBTBCQ81);
                    break;
                case "TOAKHAC_PHIEUCHUYEN":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objtkpc = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objtkpc = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptToaKhacPhieuchuyen rpttkpc = new rptToaKhacPhieuchuyen();
                    rpttkpc.DataSource = objtkpc;
                    rptView.OpenReport(rpttkpc);
                    break;
                case "TOAKHAC_PHIEUCHUYEN81":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objtkpc81 = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objtkpc81 = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptToaKhacPhieuCV81 rpttkpc81 = new rptToaKhacPhieuCV81();
                    rpttkpc81.DataSource = objtkpc81;
                    rptView.OpenReport(rpttkpc81);
                    break;
                case "TOAKHAC_PHIEUCHUYENN":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objtkpcN = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objtkpcN = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptToaKhacPhieuchuyenN rpttkpcN = new rptToaKhacPhieuchuyenN();
                    rpttkpcN.DataSource = objtkpcN;
                    DataTable vPCTK = objtkpcN.DT_NTA_PHIEUCHUYEN;
                    if (vPCTK.Rows.Count > 0)
                        rpttkpcN.DisplayName = "Phiếu chuyển " + Cls_Comon.ChuyenTVKhongDau(vPCTK.Rows[0]["TMP1"].ToString().Replace("Tòa án nhân dân", "tand")).Replace("_", " ");
                    rptView.OpenReport(rpttkpcN);
                    break;
                case "TOAKHAC_PHIEUCHUYENN81":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objtkpcN81 = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objtkpcN81 = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptToaKhacPhieuNCV81 rpttkpcN81 = new rptToaKhacPhieuNCV81();
                    rpttkpcN81.DataSource = objtkpcN81;
                    rptView.OpenReport(rpttkpcN81);
                    break;
                case "TOAKHAC_PHIEUCHUYENDS":
                    idTitle.Text = "Danh sách";
                    DTGDTTT objTKds = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTKds = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptToaKhacDanhsach rptTKDS = new rptToaKhacDanhsach();
                    rptTKDS.DataSource = objTKds;
                    rptView.OpenReport(rptTKDS);
                    break;
                case "TOAKHAC_PHIEUCHUYENGUIDS":
                    idTitle.Text = "Danh sách";
                    DTGDTTT objTKguids = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTKguids = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptToaKhacGuiDuongSu rptTKGUIDS = new rptToaKhacGuiDuongSu();
                    rptTKGUIDS.DataSource = objTKguids;
                    rptView.OpenReport(rptTKGUIDS);
                    break;
                case "TOAKHAC_THONGBAOCOQUAN":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBTKCQ = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBTKCQ = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptToaKhacThongBaoCoquan rptTKTBCQ = new rptToaKhacThongBaoCoquan();
                    rptTKTBCQ.DataSource = objTBTKCQ;
                    rptView.OpenReport(rptTKTBCQ);
                    break;
                case "KNTOAKHAC_THONGBAOCOQUAN":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBTKCQKN = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBTKCQKN = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptKNToaKhacChuyenCQ rptTKTBCQKN = new rptKNToaKhacChuyenCQ();
                    rptTKTBCQKN.DataSource = objTBTKCQKN;
                    rptView.OpenReport(rptTKTBCQKN);
                    break;
                case "NTA_PHIEUCHUYEN":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objNTApc = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objNTApc = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNTAPhieuchuyen rptntapc = new rptNTAPhieuchuyen();
                    rptntapc.DataSource = objNTApc;
                    DataTable vNTPC = objNTApc.DT_NTA_PHIEUCHUYEN;
                    if (vNTPC.Rows.Count > 0)
                        rptntapc.DisplayName = "Phiếu chuyển " + Cls_Comon.ChuyenTVKhongDau(vNTPC.Rows[0]["NGUOIGUI"].ToString());
                    rptView.OpenReport(rptntapc);
                    break;
                case "NTA_PHIEUCHUYENN":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objtNTAPCN = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objtNTAPCN = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptToaKhacPhieuchuyenN rpttkpcTN = new rptToaKhacPhieuchuyenN();
                    rpttkpcTN.DataSource = objtNTAPCN;
                    DataTable vNTPCN = objtNTAPCN.DT_NTA_PHIEUCHUYEN;
                    if (vNTPCN.Rows.Count > 0)
                        rpttkpcTN.DisplayName = "Phiếu chuyển " + Cls_Comon.ChuyenTVKhongDau(vNTPCN.Rows[0]["NGUOIGUI"].ToString());
                    rptView.OpenReport(rpttkpcTN);
                    break;
                
                case "KINHTRINHLANHDAO":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objKinhtrinh = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objKinhtrinh = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptKinhTrinhLanhDao rpkinhtrinh = new rptKinhTrinhLanhDao();
                    rpkinhtrinh.DataSource = objKinhtrinh;
                    rptView.OpenReport(rpkinhtrinh);
                    break;
                case "NTA_DANHSACH":
                    idTitle.Text = "In danh sách";
                    DTGDTTT objNTAds = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objNTAds = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNTADanhsach rptntads = new rptNTADanhsach();
                    rptntads.DataSource = objNTAds;
                    rptView.OpenReport(rptntads);
                    break;
                case "NTA_DANHSACHGUIDS":
                    idTitle.Text = "In thông báo gửi đương sự";
                    DTGDTTT objNTAdsds = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objNTAdsds = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNTAThongBaoDS rptntatbds = new rptNTAThongBaoDS();
                    rptntatbds.DataSource = objNTAdsds;
                    rptView.OpenReport(rptntatbds);
                    break;
                case "NTA_THONGBAOCOQUAN":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBNTACQ = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBNTACQ = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNTAThongBaoCoquan rptNTATBCQ = new rptNTAThongBaoCoquan();
                    rptNTATBCQ.DataSource = objTBNTACQ;
                    rptView.OpenReport(rptNTATBCQ);
                    break;
                case "NTA_TRALAI":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBTLCQ = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBTLCQ = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptTradon rptTralai = new rptTradon();
                    rptTralai.DataSource = objTBTLCQ;
                    DataTable vtb = objTBTLCQ.DT_NTA_PHIEUCHUYEN;
                    if (vtb.Rows.Count>0)
                        rptTralai.DisplayName = "Trả lại đơn " + vtb.Rows[0]["GIOITINH"].ToString() + " " + Cls_Comon.ChuyenTVKhongDau(vtb.Rows[0]["NGUOIGUI"].ToString());
                    rptView.OpenReport(rptTralai);
                    break;
                case "TRALAI_THONGBAOCOQUAN":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBTL = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBTL = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptTradonTBCQ rptTLTB = new rptTradonTBCQ();
                    rptTLTB.DataSource = objTBTL;
                    DataTable vtbcq = objTBTL.DT_NOIBO_THONGBAO;
                    if (vtbcq.Rows.Count > 0)
                        rptTLTB.DisplayName = "Trả lại đơn " + Cls_Comon.ChuyenTVKhongDau(vtbcq.Rows[0]["TENCOQUAN"].ToString().Replace("Tòa án nhân dân","tand")).Replace("_"," ");
                    rptView.OpenReport(rptTLTB);
                    break;
                case "PHANCONG_KETQUA":
                    idTitle.Text = "Kết quả phân công thẩm phán";
                    DTGDTTT objKQ = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objKQ = (DTGDTTT)Session["NOIBO_DATASET"];

                    if (Session["PHANCONG_KETQUA_HINH_THUC"] != null && Session["PHANCONG_KETQUA_HINH_THUC"].ToString() == "CHI_DINH")
                    {
                        rptKetQuaPCThamPhanChiDinh rptKQ = new rptKetQuaPCThamPhanChiDinh();
                        rptKQ.DataSource = objKQ;
                        rptView.OpenReport(rptKQ);
                    }
                    else
                    {
                        rptKetQuaPCThamPhan rptKQ = new rptKetQuaPCThamPhan();
                        rptKQ.DataSource = objKQ;
                        rptView.OpenReport(rptKQ);
                    }
                    break;
                case "NOIBO_KNTCDS":
                    idTitle.Text = "Danh sách đơn KN,TC";
                    DTGDTTT objKNDS = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objKNDS = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptKNNoiBoDanhSach rptKNDS = new rptKNNoiBoDanhSach();
                    rptKNDS.DataSource = objKNDS;
                    rptView.OpenReport(rptKNDS);
                    break;

                case "NOIBO_KNTCPHIEUCHUYENN":
                    idTitle.Text = "Thông báo";
                    DTGDTTT objKNPC = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objKNPC = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptKNPhieuchuyen rptKNPC = new rptKNPhieuchuyen();
                    rptKNPC.DataSource = objKNPC;
                    rptView.OpenReport(rptKNPC);
                    break;
                case "NOIBO_KNTCPHIEUCHUYEN1":
                    idTitle.Text = "Thông báo";
                    DTGDTTT objKNPC1 = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objKNPC1 = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptKNPhieuchuyenN rptKNPC1 = new rptKNPhieuchuyenN();
                    rptKNPC1.DataSource = objKNPC1;
                    rptView.OpenReport(rptKNPC1);
                    break;
                case "NOIBO_DSCHUADUDK":
                    idTitle.Text = "Danh sách đơn chưa đủ điều kiện";
                    DTGDTTT objCDDK = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objCDDK = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoDanhsachCDDK rptDSCDDK = new rptNoiBoDanhsachCDDK();
                    rptDSCDDK.DataSource = objCDDK;
                    rptView.OpenReport(rptDSCDDK);
                    break;
                case "NOIBO_VUANKHANGNGHI":
                    idTitle.Text = "In thông báo chuyển";
                    DTGDTTT objtbpctr1 = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objtbpctr1 = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNoiBoVuAnKhangNghi rpttbpctr1 = new rptNoiBoVuAnKhangNghi();
                    rpttbpctr1.DataSource = objtbpctr1;
                    rptView.OpenReport(rpttbpctr1);
                    break;
                // -------GELT DUCPH 20-09-2025 Them NTA PHIEU CHUYEN TINH, NTA TRA LAI TINH Chinh sua truyen vao ten tinh ---
                case "NTA_PHIEUCHUYEN_TINH":
                    idTitle.Text = "In phiếu chuyển";
                    DTGDTTT objNTApct = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objNTApct = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptNTAPhieuchuyenTinh rptntapct = new rptNTAPhieuchuyenTinh();
                    rptntapct.DataSource = objNTApct;
                    DataTable vNTPCT = objNTApct.DT_NTA_PHIEUCHUYEN;
                    if (Session["TEN_TINH"] != null)
                    {
                        rptntapct.strTenTinh = Session["TEN_TINH"].ToString();
                    }
                    if (vNTPCT.Rows.Count > 0)
                        rptntapct.DisplayName = "Phiếu chuyển " + Cls_Comon.ChuyenTVKhongDau(vNTPCT.Rows[0]["NGUOIGUI"].ToString());
                    rptView.OpenReport(rptntapct);
                    break;
                // -------GELT DUCPH  20-09-2025 Them NTA PHIEU CHUYEN TINH, NTA TRA LAI TINH Chinh sua truyen vao ten tinh ---
                case "NTA_TRALAI_TINH":
                    idTitle.Text = "Thông  báo";
                    DTGDTTT objTBTTinh = new DTGDTTT();
                    if (Session["NOIBO_DATASET"] != null)
                        objTBTTinh = (DTGDTTT)Session["NOIBO_DATASET"];
                    rptTradonTinh rptTralaiTinh = new rptTradonTinh();
                    rptTralaiTinh.DataSource = objTBTTinh;
                    DataTable vtbt = objTBTTinh.DT_NTA_PHIEUCHUYEN;
                    if (Session["TEN_TINH"] != null) // GTEL-DUCPH set tên tỉnh
                    {
                        rptTralaiTinh.strTenTinh = Session["TEN_TINH"].ToString();
                    }
                    if (vtbt.Rows.Count > 0)
                        rptTralaiTinh.DisplayName = "Trả lại đơn " + vtbt.Rows[0]["GIOITINH"].ToString() + " " + Cls_Comon.ChuyenTVKhongDau(vtbt.Rows[0]["NGUOIGUI"].ToString());
                    rptView.OpenReport(rptTralaiTinh);
                    break;
                    // -------- END ---------------------------------------
            }
        }
    }
}
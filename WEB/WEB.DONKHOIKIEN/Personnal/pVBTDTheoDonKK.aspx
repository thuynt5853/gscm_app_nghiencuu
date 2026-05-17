<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pVBTDTheoDonKK.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.pVBTDTheoDonKK" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
       
    <div class="right_full_width distance_bottom">
        <div class="thongtin_lienhe">
            <div class="right_full_width_head">
                <a href="javascript:;" class="dowload_head">Thông tin đơn khởi kiện</a>
                <div class="dangky_head_right">
                    <div class="tooltip">
                        <a href="/Personnal/DsDon.aspx">
                            <img src="../UI/img/top_back.png" style="width: 28px; float: right;" />
                        </a>
                        <span class="tooltiptext  tooltip-bottom">Quay lại</span>
                    </div>

                </div>
            </div>
            <div class="content_right">
                
                <div class="right_full_width head_title_center">
                    <span style="font-size: 15pt;">Đơn khởi kiện</span>
                </div>

                <!----------------NOI DUNG DON----------------->
                <div class="title_toaan">
                    <span>Kính gửi: </span>
                    <asp:Literal ID="lttToaAn" runat="server"></asp:Literal>
                </div>
                <div class="right_full_width">                   

                    <!---------Vu viec---------------->
                    <div class="boxchung" style="margin-top: 0px;">
                        <div class="boder" style="padding: 10px; line-height: 22px; margin-top: 0px;">
                          Noi dung vu viec

                        </div>
                    </div>


                    <!---------Thong tin thu ly---------------->
                    <asp:Panel ID="pnThuLy" runat="server">

                        <div class="boxchung" style="margin-top: 0px;">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="Literal5" runat="server" Text="Thông tin thụ lý vụ việc"></asp:Literal>
                            </h4>
                            <div class="boder" style="padding: 10px; ">

                                <asp:Repeater ID="rptThuLy" runat="server">
                                    <HeaderTemplate>
                                        <table class="table1">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td style="width:55%;"><b><%# Eval("STT") %>. Số thụ lý: </b><%#Eval("SoThuLy") %></td>
                                            <td><b>Ngày thụ lý: </b><%#Eval("NgayThuLy") %></td>
                                        </tr>
                                        <tr>
                                            <td><b>Tòa án thụ lý: </b><%#Eval("TenToaAn") %></td>
                                            <td><b>Trường hợp thụ lý: </b><%#Eval("TruongHopThuLy") %></td>
                                        </tr>
                                        <tr>
                                            <td style="vertical-align:top;" colspan="2"><b>Quan hệ pháp luật: </b> <%#Eval("TenQHPL") %></td>
                                        </tr>
                                    </ItemTemplate>
                                    <SeparatorTemplate>
                                        <tr>
                                            <td colspan="2" style="border-top: solid 1px #dcdcdc; padding-bottom: 3px;"></td>
                                        </tr>
                                    </SeparatorTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </asp:Panel>
                    <!----------------------->
                    <asp:Panel ID="pnListVBTongDat" runat="server">
                        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                        <div class="boxchung" style="margin-top: 0px;">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="Literal4" runat="server" Text="Văn bản/ Thông báo từ Tòa án"></asp:Literal>
                            </h4>
                            <div class="boder" style="padding: 10px; float: left;">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>

                                <asp:Repeater ID="rptVB" runat="server"
                                    OnItemCommand="rptVB_ItemCommand"
                                    OnItemDataBound="rptVB_ItemDataBound">
                                    <HeaderTemplate>
                                        <div class="CSSTableGenerator">
                                            <table>
                                                <tr id="row_header">
                                                    <td style="width: 20px;">TT</td>
                                                    <td>Văn bản</td>
                                                    <td>Ngày gửi</td>
                                                    <td style="width: 100px;">Trạng thái</td>
                                                    <td style="width: 60px;">Tệp đính kèm</td>
                                                </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><%#Eval("STT") %></td>
                                            <td>
                                                <asp:LinkButton ID="lkVB" runat="server" Text='<%#Eval("TenVanBan") %>'
                                                    CommandArgument='<%#Eval("VanBanID") %>' CommandName="view"></asp:LinkButton>
                                            </td>
                                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayGui")) %>
                                            </td>

                                            <td>-Trạng thái : <%#Eval("TrangThaiDoc") %><br />
                                                <%#(string.IsNullOrEmpty(Eval("NgayDoc")+""))? "": "-Ngày tiếp nhận: "+string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayDoc")) %>
                
                                            </td>
                                            <td>
                                                <div class="align_center">
                                                    <asp:ImageButton ID="imgFile" runat="server"
                                                        CommandArgument='<%#Eval("VanBanID") %>' CommandName="dowload" />
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </table>
</div>
                                    </FooterTemplate>
                                </asp:Repeater>

                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                </div>
                <!--------------------------------------------->

                <div class="fullwidth" style="text-align: center;">
                    <asp:Literal runat="server" ID="lbthongbao"></asp:Literal><br />
                    <asp:Button ID="cmdBack" runat="server" CssClass="buttoninput quaylai"
                        Text="Quay lại" />
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>

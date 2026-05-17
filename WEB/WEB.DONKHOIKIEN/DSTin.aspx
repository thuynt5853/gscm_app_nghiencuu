<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/DONKK.Master" AutoEventWireup="true" CodeBehind="DSTin.aspx.cs" Inherits="WEB.DONKHOIKIEN.DSTin" %>

<%@ Register Src="~/UserControl/MenuTin.ascx" TagPrefix="uc1" TagName="MenuTin" %>
<%@ Register Src="~/UserControl/HuongDan.ascx" TagPrefix="uc1" TagName="HuongDan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="content_center">
    <div style="float: left; width: 100%; margin-top: 20px;">
        <div class="hosoleft">
            <uc1:HuongDan runat="server" ID="HuongDan" />
        </div>
        <div class="hosoright">
            <div class="guidonkien">
                <div class="DSNew_header"><asp:Literal ID="lstheader" runat="server"></asp:Literal></div>
                <div class="DSNew_content">
                    <asp:Panel ID="pnGroupNews" runat="server">
                            <asp:Repeater runat="server" ID="rptNhomTinTuc" OnItemDataBound="rptNhomTinTuc_ItemDataBound">
                                <ItemTemplate>
                                    <asp:Panel ID="pnGroup" runat="server">
                                        <div class="tieudiem">
                                            <div class="tieudiem_head green">
                                                <asp:Literal ID="ltrTieuDeNhomTin" runat="server"></asp:Literal>
                                                <asp:Literal ID="ltrXemthem" runat="server"></asp:Literal>
                                            </div>
                                            <div class="tieudiem_content">
                                                <asp:Repeater ID="rptTinBai" runat="server" OnItemDataBound="rptTinBai_ItemDataBound">
                                                    <HeaderTemplate>
                                                        <ul class="group_othernews">
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <li>
                                                            <asp:Literal ID="ltrTinBai" runat="server"></asp:Literal>
                                                        </li>
                                                    </ItemTemplate>
                                                    <FooterTemplate></ul></FooterTemplate>
                                                </asp:Repeater>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                </ItemTemplate>
                            </asp:Repeater>
                    </asp:Panel>
                    <asp:Panel ID="pnListNews" runat="server" Visible="false">
                        <div class="tieudiem">
                            <div class="tieudiem_head green">
                                <asp:Literal ID="ltltieude" runat="server"></asp:Literal>
                            </div>
                            <div class="tieudiem_content">
                                <asp:Repeater ID="rptListTin" runat="server">
                                    <ItemTemplate>
                                        <div class="listnews_item">
                                            <div class="listnews_item_title">
                                                <a href='<%#Eval("CurrentLink") %>'>
                                                    <%#Eval("TIEUDE")%></a>
                                            </div>
                                            <p class="listnews_item_des">
                                                <%# Eval("TRICHDAN")%>
                                            </p>
                                            <div class="listnews_item_date">
                                                <%# Eval("StrNgayTinBai") %>
                                                <!--<a href='<%#Eval("CurrentLink") %>'>Xem tiếp</a>-->
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                        <asp:Panel ID="pnPhantrang" runat="server" Visible="false">
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
                            <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                             <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                        </asp:Panel>
                    </asp:Panel>
                    <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
    </div></div>
</asp:Content>
